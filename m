Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1DBWPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 18:15:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:38540 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab1DBWPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 18:15:08 -0400
Date: Sun, 3 Apr 2011 00:15:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: Jamie Iles <jamie@jamieiles.com>, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] picoxcell-otp: add support for picoxcell OTP
 devices
In-Reply-To: <20110323144230.GD17369@suse.de>
Message-ID: <alpine.LFD.2.00.1104030013070.5929@localhost6.localdomain6>
References: <1300882619-19152-1-git-send-email-jamie@jamieiles.com> <1300882619-19152-2-git-send-email-jamie@jamieiles.com> <20110323144230.GD17369@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Greg KH wrote:

> On Wed, Mar 23, 2011 at 12:16:58PM +0000, Jamie Iles wrote:
> > picoxcell devices contain a block of OTP memory that can be used for
> > storing first-stage bootloaders, cryptographic keys and other data to be
> > kept onchip.  Different devices support a number of redundancy formats
> > to cope with in-field programming errors and can be partitioned into
> > regions to allow different redundancy formats with different effective
> > sizes.
> > 
> > This patch implements an OTP device layer which different devices may
> > register their OTP regions with.
> 
> Great, but why put it in drivers/char/?  Why not drivers/otp/?

Why not drivers/mtd ? It's one time programmable memory technology
device if I'm not missing something.

Thanks,

	tglx
