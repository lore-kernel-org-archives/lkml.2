Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2DEK4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:56:06 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:27553 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2DEK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:56:04 -0400
Date: Thu, 5 Apr 2012 12:56:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] irq: remove obsolete definitions in interrupt.h
Message-ID: <20120405105601.GA18007@merkur.ravnborg.org>
References: <20120404074553.GA14959@merkur.ravnborg.org> <alpine.LFD.2.02.1204051036470.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1204051036470.2542@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 10:43:12AM +0200, Thomas Gleixner wrote:
> On Wed, 4 Apr 2012, Sam Ravnborg wrote:
> 
> > interrupt.h contained a small fixlet for the days when
> > m68k and sparc32 did not use genirq.
> > As they have both entered the modern world this
> > fixlet can be dropped.
> 
> You forgot that there is still an esoteric architecture which has
> CONFIG_GENERIC_HARDIRQS=n.
Yup.

> 
> So at least the exit_irq_thread() needs to stay.
My grepping turn up no s390 users of this. But I may have missed it.

Anyway - take this as a reminder that there is an opportunity
to clean up after m68k + sparc32 got converted.

	Sam
