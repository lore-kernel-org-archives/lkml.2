Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1G1RtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:49:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:43956 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab1G1RtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:49:15 -0400
Date: Thu, 28 Jul 2011 19:49:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Wessel <jason.wessel@windriver.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt4
In-Reply-To: <4E319F7F.8040802@windriver.com>
Message-ID: <alpine.LFD.2.02.1107281947581.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <4E319F7F.8040802@windriver.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Thu, 28 Jul 2011, Jason Wessel wrote:

> On 07/27/2011 04:37 PM, Thomas Gleixner wrote:
> >  - KGDB (not yet disabled) is reportedly unusable on -rt right now due
> >    to missing hacks in the console locking which I dropped on purpose.
> >
> To work around this in the short term you can use this patch, in
> addition to the clocksource watchdog patch that Thomas brewed up.

I pick that up as is. It's a non issue for KGDB=n

> Comments are welcome of course.  Ultimately the right solution is to
> change separation between the console and the HW to have a polled
> mode + work queue so as not to introduce any kind of latency.

Care to take a stab ?

Thanks,

	tglx
