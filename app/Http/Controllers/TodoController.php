<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tododata;

class TodoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $tododata = Tododata::all();
        return $tododata;
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $tododata = new Tododata;
        $tododata->fill($request->all())->save();

        return redirect('api/todo');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $item = Tododata::find($id);
        return $item;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $tododata = Tododata::find($id);

        $tododata->fill($request->all())->save();

        return redirect('api/todo');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $tododata = Tododata::find($id);
        $tododata->delete();

        return response()->json([
            'message' => 'Todo delete successfully'
        ],200);
    }
}
