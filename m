Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab2HXTk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:40:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38855 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760037Ab2HXTkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:40:24 -0400
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com> <5037C530.3000408@zytor.com> <20120824185741.GC5094@thunk.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120824185741.GC5094@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Drop support for x86-32
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 24 Aug 2012 12:40:12 -0700
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Brian Gerst <brgerst@gmail.com>, wbrana <wbrana@gmail.com>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <3b9ae1c8-be07-4cd4-b09f-52ff61fa14c0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heh... I just read about Android Nexus One phones being used as satellite controllers.

Theodore Ts'o <tytso@mit.edu> wrote:

>On Fri, Aug 24, 2012 at 11:17:20AM -0700, H. Peter Anvin wrote:
>> 
>> Speaking as one of the x86 maintainers... we are currently deciding
>the
>> cost/benefit tradeoff around removing i386 support.  I don't mean
>> general x86-32 support, I mean i386 as opposed to i486, Pentium, and
>so on.
>
>Random question.  As I recall the Space Shuttle and the International
>Space Station was only using 80386's because they have to be hardened
>against radiation/cosmic rays, as well as all of the other mechnical
>and thermal stresses associated with being in a spacecraft.  Is there
>any newer generation cpu's which are space-cerified at this point?
>
>(Of course, I'm rather doubtful that NASA would ever be willing to use
>Linux on something like the Curiosity Mars Rover, but I could imagine
>Linux being used in a non-mission critcal system on the ISS....)
>
>      	      		    	    	      - Ted

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
