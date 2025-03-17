## Practices

Most downstream codebases have practices to make maintaining code and porting upstream changes easier.

### Raftnetwork folder

 1. When you can, put new things or overwrite things by putting them in the **raftnetwork** folder.
 	* For example: code goes in `raftnetwork/code/`
 2. Maintain similar path structures.
 	* For example: the path for cmo job code is `code/game/jobs/job/civilians/support/cmo.dm`. So if you wanted to add/modify/overwrite cmo.dm, you would put the code in `raftnetwork/code/game/jobs/job/civilians/support/cmo.dm`.
 3. Avoid touching sprites outside of the `raftnetwork` folder as this can make conflicts which are hard to solve.

### Changes outside raftnetwork folder.

 Sometimes modifying the original document is unavoidable.

```js
/sneed/mode
	var/chuck = TRUE
	...
```

1. Removing something

```js
/sneed/mode
	// raftnetwork start
		// optional comment ...
	// var/chuck = TRUE
	// raftnetwork end
	...
```
2. Adding something.

```js
/sneed/mode
	var/chuck = TRUE
	// raftnetwork start
		// optional comment ...
	var/seeds = 5
	// raftnetwork end
	...
```
3. Modifying something.

```js
/sneed/mode
	// raftnetwork start
		// optional comment ...
	// var/chuck = TRUE
	var/chuck = FALSE
	// raftnetwork end
	...
```
### Thats it.
Some groups do more, some do less. I feel this is enough.
