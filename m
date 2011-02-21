Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1BUVUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:20:18 -0500
Received: from www.tglx.de ([62.245.132.106]:53872 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1BUVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:20:16 -0500
Date: Mon, 21 Feb 2011 22:18:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
In-Reply-To: <4D5DB83D.80205@snapgear.com>
Message-ID: <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6>
References: <4D5DB83D.80205@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Greg Ungerer wrote:
> Inside of the new arch/m68k is a little messy in the kernel and mm
> directories. There is plenty of scope for cleanup and merge on the
> files in here - but I want to leave that for follow up patches after
> this initial directory merge. As a data point, when we merged the
> m68k and m68knommu include files we had something like 70 or 80
> duplicate but separate files, after some cleanups that is now down to
> 10. Ongoing cleanup will merge some of these remaining ones as well.
> 
> Thoughts?

Hmm, how are you going to deal with the fact, that m68knommu uses
genirq, m68k not? I guess there are some more points like this
(clockevents, clocksource ...)

Is there a plan to move m68k to the generic facilities as well ?

Thanks,

	tglx
