Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab0E0R1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:27:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:38751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab0E0R1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:27:15 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527172343.GB2468@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	 <20100527155201.GA31937@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	 <20100527165931.GB1062@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	 <20100527172343.GB2468@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:26:56 +0200
Message-ID: <1274981216.27810.5605.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:23 +0100, Matthew Garrett wrote:
> ACPI provides no guarantees about what level of hardware functionality 
> remains during S3. You don't have any useful ability to determine which 
> events will generate wakeups. And from a purely practical point of view, 
> since the latency is in the range of seconds, you'll never have a low 
> enough wakeup rate to hit it. 

If all of userspace is blocked on devices, WTH is keeping us from
hitting it?
