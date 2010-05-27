Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab0E0SKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:10:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51134 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758093Ab0E0SKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:10:16 -0400
Date: Thu, 27 May 2010 19:17:16 +0100
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
Message-ID: <20100527191716.16b4a8e3@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527175030.GA3543@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527165931.GB1062@srcf.ucam.org>
	<alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<20100527172343.GB2468@srcf.ucam.org>
	<20100527184918.3d090921@lxorguk.ukuu.org.uk>
	<20100527175030.GA3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So PCs with current ACPI don't get opportunistic suspend capability. It
> > probably won't be supported on the Commodore Amiga either - your point ?
> 
> Actually, the reverse - there's no terribly good way to make PCs work 
> with scheduler-based suspend, but there's no reason why they wouldn't 
> work with the current opportunistic suspend implementation.

If one works so does the other.

> In some cases, not all. It may be a latency constraint (in which case 
> pm_qos is an appropriate mechanism), but instead it may be something 
> like "A key was pressed but never read" or "A network packet was 
> received but not delivered". These don't fit into the pm_qos model, but 
> it's state that you have to track.

I never mentioned pm_qos, just latency *and* knowing what suspend states
are acceptable. You need both.

Alan
