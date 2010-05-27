Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab0E0RTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:19:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48870 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0RTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:19:44 -0400
Date: Thu, 27 May 2010 20:18:33 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527171833.GD9625@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100526142430.327ccbc4@schatten.dmk.lab>
 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
 <20100527140655.GA28048@srcf.ucam.org>
 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
 <20100527155201.GA31937@srcf.ucam.org>
 <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
 <20100527161943.GA32764@srcf.ucam.org>
 <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 May 2010 17:18:43.0609 (UTC) FILETIME=[A8818890:01CAFDC0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 27, 2010 at 07:04:38PM +0200, ext Thomas Gleixner wrote:
>Opportunistic suspend is just a deep idle state, nothing else. If the
>overall QoS requirements allow to enter that deep idle state then the
>kernel goes there. Same decision as for all other idle states. You
>don't need any user space blocker for this decision, just sensible QoS
>information.

agree completely with you. Adding virtual differences between power 
states is a bad idea and causes unnecessary complication to the system. 
If we have a generic way of describing desired latencies (irq, wakeup, 
throughput, whatever), then the kernel should decide what's the best 
power state for the current situation.

-- 
balbi

DefectiveByDesign.org
