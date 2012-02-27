Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2B0V7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:59:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2B0V7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:59:05 -0500
Date: Mon, 27 Feb 2012 23:59:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
Message-ID: <20120227215908.GA4952@redhat.com>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 12:34:20PM -0800, Linus Torvalds wrote:
> Hey, no delays this week.
> 
> And nothing really odd going on either. Maybe things are finally calming down.
> 
> Sure, I'd have liked it to be even calmer, and there's is movement in
> various areas: btrfs updates along with scsi and media driver updates.
> And various noise elsewhere. But on the whole it's been pretty boring,
> which is just how I like it.
> 
> A couple of the fixes were directly linked to my -rc4 announcement,
> where I told people they could use a 64-bit kernel to avoid the FP
> state save/restore problem we used to have. That brought up some
> fairly corner-case compatibility issues that could make that
> impractical. So hopefully it's *true* this time around.
> 
> And while the FP state save problem is gone, if you have a 64-bit
> capable CPU but are still running a 32-bit distro, it really would be
> interesting to verify that a 64-bit kernel works for you without
> problems. Because it always *should* have, but clearly that wasn't
> always the case. It would be very interesting to hear from people who
> have perhaps tried and failed before and perhaps didn't even bother to
> report the failure? Maybe it's worth trying again?
> 
>                           Linus

Yes, I just tried.

IIRC, I used to run 64 bit upstream kernels with 32 bit userspace
under Fedora 14 (because I can) this stopped booting when I switched
to Fedora 15, I think the upstream kernel was 2.6.39 at that time,
so I stopped trying.

With 3.3.0-rc5, a 64 bit kernel works fine for me, again.
Yay!

As a side note, it's a pity that gcc in 32 bit Fedora
does not support -m 64 to support building 64 bit kernels.

-- 
MST
