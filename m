Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1ADTMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:12:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:51362 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1ADTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:12:04 -0500
Date: Tue, 4 Jan 2011 14:11:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [34-longterm 000/260] v2.6.34.8 longterm review
Message-ID: <20110104191158.GO30150@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
 <4D21A7E8.3090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D21A7E8.3090709@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jan 2011 19:11:59.0211 (UTC) FILETIME=[42B49BB0:01CBAC43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [34-longterm 000/260] v2.6.34.8 longterm review] On 03/01/2011 (Mon 11:41) Jiri Slaby wrote:

> On 01/02/2011 08:14 AM, Paul Gortmaker wrote:
> > This is the start of the longterm review cycle for the v2.6.34.8 release.
> > There are 260 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Hi, although I'm neither of that, I'm missing tty fixes. Please see:
> https://lkml.org/lkml/2010/11/29/508

For some reason lkml.org won't show me that link currently, but I've got
these patches already queued for the next round as part of watching what
Greg added to the 27 release of 32-longterm.

--------------
longterm-queue-2.6.34$grep -l Jiri next_round/*
next_round/HID-hidraw-fix-a-NULL-pointer-dereference-in-hidraw_2.patch
next_round/HID-hidraw-fix-a-NULL-pointer-dereference-in-hidraw_.patch
next_round/hpet-unmap-unused-I-O-space.patch
next_round/TTY-ldisc-fix-open-flag-handling.patch
next_round/tty-prevent-DOS-in-the-flush_to_ldisc.patch
next_round/TTY-restore-tty_ldisc_wait_idle.patch
next_round/USB-gadget-AT91-fix-typo-in-atmel_usba_udc-driver.patch
longterm-queue-2.6.34$
--------------

If you want to look around at what else is in "next_round" you can grab
the queue from:

git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.34.git

Let me know if you still think something is missing, and/or call out the
upstream commit IDs explicitly and I'll do the right thing.

Thanks,
Paul.

> and add the three in the next round.
> 
> thanks,
> -- 
> js
