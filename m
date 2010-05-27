Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab0E0Vib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:38:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36002 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab0E0Vi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:38:29 -0400
Date: Thu, 27 May 2010 22:38:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527213819.GB9916@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271724430.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005272332320.3478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272332320.3478@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:33:32PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Alan Stern wrote:
> > The two of you are talking at cross purposes.  Thomas is referring to 
> > idle-based suspend and Matthew is talking about forced suspend.
> 
> Yes, and forced suspend to disk is the same as force suspend to disk,
> which has both nothing to do with sensible resource management.

It doesn't matter. Current forced suspend to RAM is racy with respect to 
wakeup events and should be fixed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
