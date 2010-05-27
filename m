Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0E0QUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:20:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44220 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0QUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:20:01 -0400
Date: Thu, 27 May 2010 17:19:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527161943.GA32764@srcf.ucam.org>
References: <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:16:15PM +0100, Alan Cox wrote:

> I can't speak for Thomas, but I'm certainly not arguing that you don't
> need something that looks more like the blocker side of the logic *in
> kernel*, because there is stuff that you want to express which isn't tied
> to the task.

Sure, if you're not using opportunistic suspend then I don't think 
there's any real need for the userspace side of this. The question is 
how to implement something with the useful properties of opportunistic 
suspend without without implementing something pretty much equivalent to 
the userspace suspend blockers. I've sent another mail expressing why I 
don't think your proposed QoS style behaviour provides that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
