Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934947Ab0E0SXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:23:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43069 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0E0SXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:23:21 -0400
Date: Thu, 27 May 2010 19:23:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527182303.GM3543@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <20100527184918.3d090921@lxorguk.ukuu.org.uk> <20100527175030.GA3543@srcf.ucam.org> <alpine.LFD.2.00.1005272015360.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272015360.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:18:49PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > Actually, the reverse - there's no terribly good way to make PCs work 
> > with scheduler-based suspend, but there's no reason why they wouldn't 
> > work with the current opportunistic suspend implementation.
> 
> How does that solve the problems you mentioned above ? Wakeup
> guarantees, latencies ...

Latency doesn't matter because we don't care when the next timer is due 
to expire. Wakeup guarantees can be provided via the suspend blocker 
implementation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
