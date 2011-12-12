Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1LLRXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:23:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab1LLRXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:23:34 -0500
Date: Mon, 12 Dec 2011 18:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212172148.GD23870@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
 <20111212102750.469f0d9f@pyramind.ukuu.org.uk>
 <1323687592.16450.0.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323687592.16450.0.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> > You can emulate a chip with a 64byte or so FIFO. You can do 
> > I/O cycle prediction in the kernel part and you can use the 
> > empty bit as a clue (which is what most serial<->ethernet 
> > widgetry does).
> 
> The performance problems here aren't the same performance 
> problems you have on real hardware. The problem here is that 
> it costs 40k cycles for the guest to access the emulated chip.

I question that 40k cycles figure - where does Marcelo's paper 
mention it?

Thanks,

	Ingo
