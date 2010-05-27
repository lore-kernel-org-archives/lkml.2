Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0E0Ofc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:35:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40635 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0E0Of3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:35:29 -0400
Date: Thu, 27 May 2010 15:35:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527143508.GA30117@srcf.ucam.org>
References: <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <1274970531.27810.5024.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274970531.27810.5024.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 04:28:51PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 15:06 +0100, Matthew Garrett wrote:
> > one way which indicates to the scheduler that tasks in TASK_RUNNING 
> > should be scheduled, and when the session is idle we set the flag the 
> > other way and all processes in that cgroup get shifted to 
> > TASK_INTERRUPTIBLE or something.
> 
> What's wrong with simply making the phone beep loudly and displaying:
> bouncing cows is preventing your phone from sleeping!

Well, primarily that it's possible to design an implementation where it 
*doesn't* prevent your phone froms sleeping, but also because a given 
application may justifiably be preventing your phone from sleeping for a 
short while. What threshold do you use to determine the difference?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
