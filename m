Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2GNLBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 07:01:24 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59675 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab2GNLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 07:01:00 -0400
Date: Sat, 14 Jul 2012 07:00:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/CodingStyle: Numerous pedantic cleanups,
 nothing major.
Message-ID: <alpine.DEB.2.02.1207140656040.7072@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  while i was perusing CodingStyle, i did some tidying up along the
way.  i won't take it personally if someone decides not to bother with
this, it's all pretty minor.

  this is all independent of the earlier macro explanation.


diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index cb9258b..7544702 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -2,7 +2,7 @@
 		Linux kernel coding style

 This is a short document describing the preferred coding style for the
-linux kernel.  Coding style is very personal, and I won't _force_ my
+Linux kernel.  Coding style is very personal, and I won't _force_ my
 views on anybody, but this is what goes for anything that I have to be
 able to maintain, and I'd prefer it for most other things too.  Please
 at least consider the points made here.
@@ -16,7 +16,7 @@ Anyway, here goes:
 	 	Chapter 1: Indentation

 Tabs are 8 characters, and thus indentations are also 8 characters.
-There are heretic movements that try to make indentations 4 (or even 2!)
+There are heretical movements that try to make indentations 4 (or even 2!)
 characters deep, and that is akin to trying to define the value of PI to
 be 3.

@@ -32,7 +32,7 @@ more than 3 levels of indentation, you're screwed anyway, and should fix
 your program.

 In short, 8-char indents make things easier to read, and have the added
-benefit of warning you when you're nesting your functions too deep.
+benefit of warning you when you're nesting your functions too deeply.
 Heed that warning.

 The preferred way to ease multiple indentation levels in a switch statement is
@@ -122,14 +122,14 @@ opening brace at the beginning of the next line, thus:
 		body of function
 	}

-Heretic people all over the world have claimed that this inconsistency
+Heretical people all over the world have claimed that this inconsistency
 is ...  well ...  inconsistent, but all right-thinking people know that
 (a) K&R are _right_ and (b) K&R are right.  Besides, functions are
 special anyway (you can't nest them in C).

 Note that the closing brace is empty on a line of its own, _except_ in
-the cases where it is followed by a continuation of the same statement,
-ie a "while" in a do-statement or an "else" in an if-statement, like
+the cases where it is followed by a continuation of the same statement;
+ie, a "while" in a do-statement or an "else" in an if-statement, like
 this:

 	do {
@@ -150,7 +150,7 @@ Rationale: K&R.

 Also, note that this brace-placement also minimizes the number of empty
 (or almost empty) lines, without any loss of readability.  Thus, as the
-supply of new-lines on your screen is not a renewable resource (think
+supply of newlines on your screen is not a renewable resource (think
 25-line terminal screens here), you have more empty lines to put
 comments on.

@@ -338,7 +338,7 @@ Maybe there are other cases too, but the rule should basically be to NEVER
 EVER use a typedef unless you can clearly match one of those rules.

 In general, a pointer, or a struct that has elements that can reasonably
-be directly accessed should _never_ be a typedef.
+be directly accessed, should _never_ be a typedef.


 		Chapter 6: Functions
@@ -386,7 +386,8 @@ because it is a simple way to add valuable information for the reader.
 		Chapter 7: Centralized exiting of functions

 Albeit deprecated by some people, the equivalent of the goto statement is
-used frequently by compilers in form of the unconditional jump instruction.
+used frequently by compilers in the form of the unconditional jump
+instruction.

 The goto statement comes in handy when a function exits from multiple
 locations and some common work such as cleanup has to be done.
@@ -420,6 +421,7 @@ out:
 	return result;
 }

+
 		Chapter 8: Commenting

 Comments are good, but there is also a danger of over-commenting.  NEVER
@@ -501,7 +503,7 @@ values.  To do the latter, you can stick the following in your .emacs file:
                 (setq indent-tabs-mode t)
                 (c-set-style "linux-tabs-only")))))

-This will make emacs go better with the kernel coding style for C
+This will make emacs work better with the kernel coding style for C
 files below ~/src/linux-trees.

 But even if you fail in getting emacs to do sane formatting, not
@@ -713,7 +715,7 @@ that can go into these 5 milliseconds.

 A reasonable rule of thumb is to not put inline at functions that have more
 than 3 lines of code in them. An exception to this rule are the cases where
-a parameter is known to be a compiletime constant, and as a result of this
+a parameter is known to be a compile-time constant, and as a result of this
 constantness you *know* the compiler will be able to optimize most of your
 function away at compile time. For a good example of this later case, see
 the kmalloc() inline function.



rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
