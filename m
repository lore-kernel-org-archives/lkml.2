Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0E0TwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:52:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37243 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759569Ab0E0TwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:52:23 -0400
Date: Thu, 27 May 2010 20:59:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527205916.1659374e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527182303.GM3543@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527165931.GB1062@srcf.ucam.org>
	<alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<20100527172343.GB2468@srcf.ucam.org>
	<20100527184918.3d090921@lxorguk.ukuu.org.uk>
	<20100527175030.GA3543@srcf.ucam.org>
	<alpine.LFD.2.00.1005272015360.3032@localhost.localdomain>
	<20100527182303.GM3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 19:23:03 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 08:18:49PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > Actually, the reverse - there's no terribly good way to make PCs work 
> > > with scheduler-based suspend, but there's no reason why they wouldn't 
> > > work with the current opportunistic suspend implementation.
> > 
> > How does that solve the problems you mentioned above ? Wakeup
> > guarantees, latencies ...
> 
> Latency doesn't matter because we don't care when the next timer is due 
> to expire.

In your specific current implementation. It matters a hell of a lot in
most cases.

Alan
