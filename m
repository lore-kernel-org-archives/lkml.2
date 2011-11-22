Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1KVXRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:17:00 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39343 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab1KVXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:16:59 -0500
Date: Wed, 23 Nov 2011 08:16:56 +0900
From: Norbert Preining <preining@logic.at>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression 3.1.0 -> 3.20rc] USB Oops
Message-ID: <20111122231656.GB15722@gamma.logic.tuwien.ac.at>
References: <20111122125256.GB32440@gamma.logic.tuwien.ac.at> <Pine.LNX.4.44L0.1111221131170.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111221131170.2466-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 22 Nov 2011, Alan Stern wrote:
> > [   67.852328] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d9
> > [   67.853898] IP: [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]
> 
> This is odd.  I've never seen a problem in that routine before.
> 
> What is "last_sector_hacks.part.2"?  In my kernel source tree there is
> a last_sector_hacks() function in drivers/usb/storage/transport.c, but
> what does the ".part.2" refer to?

No idea, here I am compiling with default Debian sid gcc, that is
gcc (Debian 4.6.2-4) 4.6.2

Anything else I can do? Should I hack something into the code?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HEATON PUNCHARDON (n.) A violent argument which breaks out in the car
on the way home from a party between a couple who have had to be
polite to each other in company all evening.
			--- Douglas Adams, The Meaning of Liff
