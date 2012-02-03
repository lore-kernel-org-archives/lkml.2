Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2BCKIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:08:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57173 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2BCKIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:08:10 -0500
Date: Fri, 3 Feb 2012 11:07:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: [PATCH] SubmittingPatches: Increase the line length limit from 80 to
 100 colums
Message-ID: <20120203100743.GA3334@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203095227.GA13162@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > If we want to increase the standard to (say) 96 cols then 
> > fine, I'd be happy with that.  But until we do that we 
> > should not create such a gruesome mess for those who use 80 
> > cols.
> 
> The kernel has *already* become a gruesome mess for 80 col 
> users long ago. That was the main reason why I stopped using 
> 80 col terminals two years ago ...
> 
> So lets stop the pretense.

in other words:

--------------->
[PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums

The overwhelming majority of kernel developers have stopped 
using 80 col terminals years ago.

As far as I'm aware I was the last regular kernel contributor 
who still used a standard VGA text console, but both text 
consoles and using them to read the kernel source code has 
become increasingly gruesome years ago so I switched to a wider 
terminal two years ago.

Worse than that, people are actively uglifying the kernel code 
to fit things into 80 cols mechanically. They are using 
checkpatch and are interpreting the 80 col warnings the wrong 
way again and again, sucking up reviewer bandwidth that could be 
utilized better.

So lets increase the limit to 100 cols - this is a nice round 
limit, and it also happens to match with most developer xterm 
sizes. Code that goes over 100 cols for no good reasons will be 
arguably something worth fixing. (100 cols is also arguably 
closer to various brain limits such as vision of field and 
resolution restrictions, so we'll likely not have to increase 
this limit for a couple of million years, for all retro human 
genome users.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 2b90d32..e87370f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -27,7 +27,7 @@ how the indentation works if you have large indentations.
 
 Now, some people will claim that having 8-character indentations makes
 the code move too far to the right, and makes it hard to read on a
-80-character terminal screen.  The answer to that is that if you need
+100-character terminal screen.  The answer to that is that if you need
 more than 3 levels of indentation, you're screwed anyway, and should fix
 your program.
 
@@ -77,11 +77,11 @@ Get a decent editor and don't leave whitespace at the end of lines.
 Coding style is all about readability and maintainability using commonly
 available tools.
 
-The limit on the length of lines is 80 columns and this is a strongly
+The limit on the length of lines is 100 columns and this is a strongly
 preferred limit.
 
-Statements longer than 80 columns will be broken into sensible chunks, unless
-exceeding 80 columns significantly increases readability and does not hide
+Statements longer than 100 columns will be broken into sensible chunks, unless
+exceeding 100 columns significantly increases readability and does not hide
 information. Descendants are always substantially shorter than the parent and
 are placed substantially to the right. The same applies to function headers
 with a long argument list. However, never break user-visible strings such as
@@ -344,8 +344,7 @@ be directly accessed should _never_ be a typedef.
 		Chapter 6: Functions
 
 Functions should be short and sweet, and do just one thing.  They should
-fit on one or two screenfuls of text (the ISO/ANSI screen size is 80x24,
-as we all know), and do one thing and do that well.
+fit on one or two screenfuls of text, and do one thing and do that well.
 
 The maximum length of a function is inversely proportional to the
 complexity and indentation level of that function.  So, if you have a
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..2d0f093 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1726,15 +1726,14 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+#100 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
+		    $length > 100)
 		{
-			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+			WARN("LONG_LINE", "line over 100 characters\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline

