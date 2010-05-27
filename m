Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0E0TCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:02:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41336 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756758Ab0E0TCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:02:52 -0400
Date: Thu, 27 May 2010 20:09:50 +0100
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
Message-ID: <20100527200950.44305cef@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527182058.GL3543@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527165931.GB1062@srcf.ucam.org>
	<alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<20100527172343.GB2468@srcf.ucam.org>
	<20100527184918.3d090921@lxorguk.ukuu.org.uk>
	<20100527175030.GA3543@srcf.ucam.org>
	<20100527191716.16b4a8e3@lxorguk.ukuu.org.uk>
	<20100527182058.GL3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If one works so does the other.
> 
> Not at all. The entire point of opportunistic suspend is that I don't 
> care is currently in TASK_RUNNABLE or has a timer that's due to expire 
> in 100msec - based on policy (through not having any held suspend 
> blockers), I'll go to sleep. That's easily possible on PCs.

Yes I appreciate what suspend blockers are trying to do. Now how does
that connect with my first sentence ?
