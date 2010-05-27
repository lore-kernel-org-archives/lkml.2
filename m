Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0E0RVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:21:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51966 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0E0RVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:21:41 -0400
Date: Thu, 27 May 2010 19:21:35 +0200
From: Florian Mickler <florian@mickler.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527192135.6c6543b3@schatten.dmk.lab>
In-Reply-To: <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 18:45:25 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> The whole notion of treating suspend to RAM any different than a plain
> idle C-State is wrong. It's not different at all. You just use a
> different mechanism which has longer takedown and wakeup latencies and
> requires to shut down stuff and setup extra wakeup sources.
> 
> And there is the whole problem. Switching from normal event delivery
> to those special wakeup sources. That needs to be engineered in any
> case carefuly and it does not matter whether you add suspend blockers
> or not.

Ok, I just don't know the answer: How is it just another idle state if
the userspace gets frozen? Doesn't that bork the whole transition and
you need a userspace<->kernel synchronisation point to not loose events?

Cheers,
Flo
