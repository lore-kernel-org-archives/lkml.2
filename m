Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab0E0SRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:17:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41734 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab0E0SRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:17:24 -0400
Date: Thu, 27 May 2010 19:17:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527181712.GI3543@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain> <20100527173118.GE2468@srcf.ucam.org> <alpine.LFD.2.00.1005271959450.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271959450.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:05:39PM +0200, Thomas Gleixner wrote:

> You're just not getting it. If user space has consumed the event is
> not relevant at all.
> 
> What's relevant is whether the app has processed the event and reacted
> accordingly. That's all that matters.

And how do you know that? We can't rely on the process scheduler.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
