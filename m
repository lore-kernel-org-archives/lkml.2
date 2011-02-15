Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1BOSty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:49:54 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46813 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1BOStv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JHGubgnp9TFgr3ZxAs0dO2IlLnzcZGUibwapXnFKADltHFgZURPXd/KDzPTr1cT8X7
         14FJXh5z3+nIQ/W5mhyGoVWkk6qJod2FDk8FvpOiVRFg7UYvZ/bpw9YuUjM6rFnkOZB8
         30JRQ9EIMMGKsloRI6AC5XHT2arNvt/mawNHc=
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 10:49:50 -0800
Message-ID: <AANLkTimkkKWk2coNJfQLo5naqZwjGxW9s650J7hE5Arp@mail.gmail.com>
Subject: GC lingua franca
From: Keith Curtis <keithcu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Science doesn’t always proceed at the speed of thought. It often
proceeds at sociological or even demographic speed. — John Tooby

Open Letter to the LKML;

If we were already talking to our computers, etc. as we should be, I
wouldn’t feel a need to write this to you. Given current rates of
adoption, Linux still seems a generation away from being the priceless
piece of free software useful to every child and PhD. This army your
kernel enables has millions of people, but they often lose to smaller
proprietary armies, because they are working inefficiently. My mail
one year ago (http://keithcu.com/wordpress/?p=272) listed the biggest
workitems, but I realize now I should have focused on one. In a
sentence, I have discovered that we need GC lingua franca(s).
(http://www.merriam-webster.com/dictionary/lingua%20franca)

Every Linux success builds momentum, but the desktop serves as a
powerful daily reminder of the scientific tradition. Many software
PhDs publish papers but not source, like Microsoft. I attended a human
genomics conference and found that the biotech world is filled with
proprietary software. IBM’s Jeopardy-playing Watson is proprietary,
like Deep Blue was. This topic is not discussed in any of the news
articles, as if the license does not matter. I find widespread fear of
having ideas stolen in the software industry, and proprietary licenses
encourage this. We need to get these paranoid programmers, hunched in
the shadows, scribbled secrets clutched in their fists, working
together, for any of them to succeed. Desktop world domination is not
necessary, but it is sufficient to get robotic chaffeurs and butlers.
Windows is not the biggest problem, it is the proprietary licensing
model that has infected computing, and science.

There is, unsurprisingly, a consensus among kernel programmers that
usermode is “a mess” today, which suggests there is a flaw in the
Linux desktop programming paradigm. Consider the vast expanse of XML
libraries in a Linux distribution. Like computer vision
(http://www.cs.cmu.edu/~cil/v-source.html), there are not yet clear
places for knowledge to accumulate. It is a shame that the kernel is
so far ahead of most of the rest of user mode.

The most popular free computer vision codebase is OpenCV, but it is
time-consuming to integrate because it defines an entire world in C++
down to the matrix class. Because C/C++ didn’t define a matrix, nor
provide code, countless groups have created their own. It is easier to
build your own computer vision library using standard classes that do
math, I/O, and graphics, than to integrate OpenCV. Getting productive
in that codebase is months of work and people want to see results
before then. Building it is a chore, and they have lost users because
of that. Progress in the OpenCV core is very slow because the barriers
to entry are high. OpenCV has some machine learning code, but they
would be better delegating that out to others. They are now doing CUDA
optimizations they could get from elsewhere. They also have 3 Python
wrappers and several other wrappers as well; many groups spend more
time working on wrappers than the underlying code. Using the wrappers
is fine if you only want to call the software, but if you want to
improve OpenCV then the programming environment instantly becomes
radically different and more complicated.

There is a team working on Strong AI called OpenCog, a C++ codebase
created in 2001. They are evolving slowly as they do not have a
constant stream of demos. They don’t consider their codebase is a
small amount of world-changing ideas buried in engineering baggage
like STL. Their GC language for small pieces is Scheme, an unpopular
GC language in the FOSS community. Some in their group recommend
Erlang. The OpenCog team looks at their core of C++, and over to
OpenCV’s core of C++, and concludes the situation is fine. One of the
biggest features of the ROS (Robot OS), according to its
documentation, is a re-implementation of RPC in C++, not what robotics
was missing. I’ve emailed various groups and all know of GC, but they
are afraid of any decrease in performance, and they do not think they
will ever save time. The transition from brooms to vacuum cleaners was
disruptive, but we managed.

C/C++ makes it harder to share code amongst disparate scientists than
a GC language. It doesn’t matter if there are lots of XML parsers or
RSS readers, but it does matter if we don’t have an official computer
vision codebase. This is not against any codebase or language, only
for free software lingua franca(s) in certain places to enable faster
knowledge accumulation. Even language researchers can improve and
create variants of a common language, and tools can output it from
other domains like math. Agreeing on a standard still gives us an
uncountably infinite number of things to disagree over.

Because the kernel is written in C, you’ve strongly influenced the
rest of community. C is fully acceptable for a mature kernel like
Linux, but many concepts aren’t so clear in user mode. What is the UI
of OpenOffice where speech input is the primary means of control? Many
scientists don’t understand the difference between the stack and the
heap. Software isn’t buildable if those with the necessary expertise
can’t use the tools they are given.

C is a flawed language for user mode because it is missing GC,
invented a decade earlier, and C++ added as much as it took away as
each feature came with an added cost of complexity. C++ compilers
converting to C was a good idea, but being a superset was not. C/C++
never died in user mode because there are now so many GC replacements,
it created a situation paralyzing many to inaction, as there seems no
clear place to go. Microsoft doesn’t have this confusion as their
language, as of 2001, is C#. Microsoft is steadily moving to C#, but
it is 10x easier to port a codebase like MySQL than SQL Server, which
has an operating system inside. C# is taking over at the edges first,
where innovation happens anyway. There is a competitive aspect to
this.

Lots of free software technologies have multiple C/C++
implementations, because it is often easier to re-write than share,
and an implementation in each GC language. We all might not agree on
the solution, so let’s start by agreeing on the problem. A good
example for GC is how a Mac port can go from weeks to hours. GC also
prevents code from being able to use memory after freeing, free twice,
etc. and therefore that user code is less likely to corrupt your
memory hardware. If everyone in user mode were still writing in
assembly language, you would obviously be concerned. If Git had been
built in 98% Python and 2% C, it would have become easier to use
faster, found ways to speed up Python, and set a good example. It
doesn’t matter now, but it was an opportunity in 2005.

You can “leak” memory in GC, but that just means that you are still
holding a reference. GC requires the system to have a fuller
understanding of the code, which enables features like reflection. It
is helpful to consider that GC is a step-up for programming like C was
to assembly language. In Lisp the binary was the source code — Lisp is
free by default. The Baby Boomer generation didn’t bring the tradition
of science to computers, and the biggest legacy of this generation is
if we remember it. Boomers gave us proprietary software, C, C++, Java,
and the bankrupt welfare state. Lisp and GC were created / discovered
by John McCarthy, a mathematician of the WW II greatest generation. He
wrote that computers of 1974 were fast enough to do Strong AI. There
were plenty of people working on it back then, but not in a group big
enough to achieve critical mass. If they had, we’d know their names.
If our scientists had been working together in free software and Lisp
in 1959, the technology we would have developed by today would seem
magical to us. The good news is that we have more scientists than we
need.

There are a number of good languages, and it doesn’t matter too much
what one is chosen, but it seems the Python family (Cython / PyPy)
require the least amount of work to get what we need as it has the
most extensive libraries: http://scipy.org/Topical_Software. I don’t
argue the Python language and implementation is perfect, ﻿﻿only good
enough, like how the shape of the letters of the English language are
good enough. Choosing and agreeing on a lingua franca will increase
the results for the same amount of effort. No one has to understand
the big picture, they just have to do their work in a place where
knowledge can easily accumulate. A GC lingua franca isn’t a silver
bullet, but it is the bottom piece of a solid science foundation and a
powerful form of social engineering.

The most important thing is to get lingua franca(s) in key fields like
computer vision and Strong AI. However, we should also consider a
lingua franca for the Linux desktop. This will help, but not solve,
the situation of the mass of Linux apps feeling dis-integrated. The
Linux desktop is a lot harder because code here is 100x bigger than
computer vision, and there is a lot of C/C++ in FOSS user mode today.
In fact it seems hopeless to me, and I’m an optimist. It doesn’t
matter; every team can move at a different pace. Many groups might not
be able to finish a port for 5 years, but agreeing on a goal is more
than half of the battle. The little groups can adopt it most quickly.

There are a lot of lurkers around codebases who want to contribute but
don’t want to spend months getting up to speed on countless tedious
things like learning a new error handling scheme. They would be happy
to jump into a port as a way to get into a codebase. Unfortunately,
many groups don’t encourage these efforts as they feel so busy. Many
think today’s hardware is too slow, and that running any slower would
doom the effort; they are impervious to the doublings and forget that
algorithm performance matters most. A GC system may add a one-time
cost of 5-20%, but it has the potential to be faster, and it gives
people more time to work on performance. There are also real-time,
incremental, and NUMA-aware collectors. The ultimate in performance is
taking advantage of parallelism in specialized hardware like GPUs, and
a GC language can handle that because it supports arbitrary bitfields.

Science moves at demographic speed when knowledge is not being reused
among the existing scientists. A lingua franca makes more sense as
more adopt it. That is why I send this message to the main address of
the free software mothership. The kernel provides code and leadership,
you have influence and the responsibility to lead the rest, who are
like wandering ants. If I were Linus, I would threaten to quit Linux
and get people going on AI ;-) There are many things you could do. I
mostly want to bring this to your attention. Thank you for reading
this.

I am posting a copy of this open letter on my blog as well
(http://keithcu.com/wordpress/?p=1691). Reading the LKML for more than
one week could be classified as torture under the Geneva conventions.

In liberty,

-Keith
