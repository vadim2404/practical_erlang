-module(matrix_zipper).

-export([from_matrix/1, to_matrix/1,
         left/1, left/2,
         right/1, right/2,
         up/1, up/2,
         down/1, down/2,
         get/1, set/2,
         position/1,
         find/2
        ]).

-type matrix() :: [[any()]].
-type mz() :: list_zipper:lz().
-export_type([matrix/0, mz/0]).


%%% Module API

-spec from_matrix(matrix()) -> mz().
from_matrix(Matrix) ->
    Rows = lists:map(fun list_zipper:from_list/1, Matrix),
    list_zipper:from_list(Rows).


-spec to_matrix(mz()) -> matrix().
to_matrix(Zipper) ->
    Rows = list_zipper:to_list(Zipper),
    lists:map(fun list_zipper:to_list/1, Rows).


-spec get(mz()) -> any().
get(Zipper) ->
    CurrRow = list_zipper:get(Zipper),
    list_zipper:get(CurrRow).


-spec set(mz(), any()) -> mz().
set(Zipper, Value) ->
    CurrRow = list_zipper:get(Zipper),
    CurrRow2 = list_zipper:set(CurrRow, Value),
    list_zipper:set(Zipper, CurrRow2).


-spec left(mz()) -> mz().
left(Zipper) ->
    move_in_curr_row(Zipper, left, 1).


-spec left(mz(), pos_integer()) -> mz().
left(Zipper, Steps) ->
    move_in_curr_row(Zipper, left, Steps).


-spec right(mz()) -> mz().
right(Zipper) ->
    move_in_curr_row(Zipper, right, 1).


-spec right(mz(), pos_integer()) -> mz().
right(Zipper, Steps) ->
    move_in_curr_row(Zipper, right, Steps).


-spec up(mz()) -> mz().
up(Zipper) ->
    change_row(Zipper, left, 1).


-spec up(mz(), pos_integer()) -> mz().
up(Zipper, Steps) ->
    change_row(Zipper, left, Steps).


-spec down(mz()) -> mz().
down(Zipper) ->
    change_row(Zipper, right, 1).


-spec down(mz(), pos_integer()) -> mz().
down(Zipper, Steps) ->
    change_row(Zipper, right, Steps).


-spec position(mz()) -> {pos_integer(), pos_integer()}.
position(Zipper) ->
    CurrRow = list_zipper:get(Zipper),
    {list_zipper:position(CurrRow), list_zipper:position(Zipper)}.


-spec find(mz(), term()) -> {ok, mz()} | {error, not_found}.
find(Zipper, _Value) ->
    %% TODO need list_zipper:find
    {ok, Zipper}.


%%% Inner Functions

move_in_curr_row(Zipper, Direction, Steps) ->
    CurrRow = list_zipper:get(Zipper),
    CurrRow2 = list_zipper:Direction(CurrRow, Steps),
    list_zipper:set(Zipper, CurrRow2).


change_row(Zipper, Direction, Steps) ->
    OldRow = list_zipper:get(Zipper),
    OldRowPos = list_zipper:position(OldRow),
    Zipper2 = list_zipper:Direction(Zipper, Steps),
    NewRow = list_zipper:get(Zipper2),
    NewRowPos = list_zipper:position(NewRow),
    list_zipper:set(Zipper2,
                    if
                        NewRowPos == OldRowPos -> NewRow;
                        NewRowPos > OldRowPos -> list_zipper:left(NewRow, NewRowPos - OldRowPos);
                        NewRowPos < OldRowPos -> list_zipper:right(NewRow, OldRowPos - NewRowPos)
                    end).
