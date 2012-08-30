Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2H3BON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 21:14:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:35253 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab2H3BOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 21:14:12 -0400
Date: Wed, 29 Aug 2012 18:14:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Theodore Ts'o" <tytso@mit.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
In-Reply-To: <20120824185741.GC5094@thunk.org>
Message-ID: <alpine.DEB.2.02.1208291812590.13536@asgard.lang.hm>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
 <5037C530.3000408@zytor.com> <20120824185741.GC5094@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Theodore Ts'o wrote:

> On Fri, Aug 24, 2012 at 11:17:20AM -0700, H. Peter Anvin wrote:
>>
>> Speaking as one of the x86 maintainers... we are currently deciding the
>> cost/benefit tradeoff around removing i386 support.  I don't mean
>> general x86-32 support, I mean i386 as opposed to i486, Pentium, and so on.
>
> Random question.  As I recall the Space Shuttle and the International
> Space Station was only using 80386's because they have to be hardened
> against radiation/cosmic rays, as well as all of the other mechnical
> and thermal stresses associated with being in a spacecraft.  Is there
> any newer generation cpu's which are space-cerified at this point?
>
> (Of course, I'm rather doubtful that NASA would ever be willing to use
> Linux on something like the Curiosity Mars Rover, but I could imagine
> Linux being used in a non-mission critcal system on the ISS....)

I've heard that there are radiation hardened versions of the 80486 (I 
could be wrong, it's not something that I've ever needed to investigate)

David Lang
