Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423803Ab2LGSS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:18:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61336 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423658Ab2LGSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:18:27 -0500
Date: Fri, 7 Dec 2012 10:18:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@air.linux-foundation.org
To: Ric Wheeler <rwheeler@redhat.com>
cc: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
In-Reply-To: <50C22923.90102@redhat.com>
Message-ID: <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Dec 2012, Ric Wheeler wrote:
> 
> Review is part of the way we work as a community and we should figure out how
> to fix our review process so that we can have meaningful results from the
> review or we lose confidence in the process and it makes it much harder to get
> reviewers to spend time reviewing when their reviews are ultimately ignored.

Christ, I promised myself to not respond any more to this thread, but the 
insanity just continues, from people who damn well should know better.

The code wasn't merged. The review worked.

What you (and Dave, and Christoph) are trying to do is shut down a feature 
that somebody else decided they needed. That's not what code review is all 
about, and dammit, don't try to even claim it is.

So stop these dishonest and disingenious arguments. They are full of crap.

No amount of "review" has any meaning what-so-ever on whether somebody 
else decides they need a feature or not. You can review all you want, but 
it's irrelevant - if some company decides they are going to ship or use a 
feature, it's out of your hands.

What got merged was a ONE-LINER to make sure that possible future 
development didn't unnecessarily make things any more confusing, with the 
knowledge that there was a user of the code you didn't like. 

Every single argument I've heard of from the "please revert" camp has been 
inane. And they've been *transparently* inane, to the point where I don't 
understand how you can make them with a straght face and not be ashamed.

The arguments have been:

 - the code failed review, and shouldn't have been merged.

   Fine, and the code *wasn't* merged. What was merged was just a note in 
   the source code so that other people will know not to stomp on things 
   pointlessly so that things would get confusing for no reason.

 - "We have a process, and things should be done on the mailing list".

   Bullshit. What ended up in the tree was a one-liner patch that couldn't 
   possibly break anything, and fixed a small and trivial issue that 
   nobody should ever have even cared about (much less result in these 
   inane long threads)

   Anybody who claims that our "process" requires that things like that go 
   on the mailing list and pass long reviews and discussions IS JUST 
   LYING.

   Because it's not true. We discuss big features, and we want code 
   review, yes, but the fact is, most small obvious patches do *not* get 
   reviewed, they just get fixed. You all know that, why the hell are you 
   suddenly claiming that this is so magically different?

 - The "it's now open season and anything can be merged without review" 
   sky-is-falling argument (and yes, seriously, I've seen that insane 
   statement in this thread too, by a person who I thought was saner than 
   that)

   Read the above arguments, and realise how shrill and outright STUPID 
   that kind of "we can now do anything without review" argument is.

 - the totally unsupported claim that the patch that people are 
   complaining about is "bad". Christoph has now said so multiple times, 
   without ever actually backing it up in any way.

   Christoph: I can well imagine that you don't like the code that google 
   apparently uses. BUT THAT ISN'T WHAT YOU ARE ARGUING FOR REVERTING!

   You seem to seriously argue that it's a *bad* thing to put a note that 
   one bit is already in use. That's f*cking moronic. You are arguing that 
   it is bad idea to let people know about possible clashes. Really?

Guys, it's not like anybody else even wants to *use* the bit that was 
marked! If we were running out of bits, then the argument "That bit could 
be used for better, and we don't care about some random out-of-tree use" 
would be perfectly valid. And maybe we will revisit this in a year (or 
five) due to issues like that.

And that's _fine_. Once you have actual technical arguments ("I'd like to 
re-appropriate that bit, because xyzzy") you have real and valid 
arguments, and it would be easy to then do the sane "let's just use the 
bit for something more worthy" thing. But even then it's nice to have the 
knowledge about what the implications of such use would be, for chrissake!

But that's not what the insane and pointless arguments in this thread have 
been. The whole thread has been just choch-full of pure STUPID.

Please stop the inane and idiotic arguments already. The "we must review 
every one-liner, and this destroys and makes a mockery of our review 
process" argument in particular has been dishonest and pure crap. What has 
made this simple and obvious patch so special in your minds?

                   Linus
