Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0E0RmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:42:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:32910 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab0E0Rl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:41:58 -0400
Date: Thu, 27 May 2010 18:41:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527174140.GB3187@srcf.ucam.org>
References: <20100527161943.GA32764@srcf.ucam.org> <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain> <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins> <20100527171644.GA2468@srcf.ucam.org> <1274980856.27810.5582.camel@twins> <20100527172510.GC2468@srcf.ucam.org> <1274981288.27810.5609.camel@twins> <20100527173218.GF2468@srcf.ucam.org> <1274981750.27810.5641.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274981750.27810.5641.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:35:50PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 18:32 +0100, Matthew Garrett wrote:
> > On Thu, May 27, 2010 at 07:28:08PM +0200, Peter Zijlstra wrote:
> > > Why would you care about the screen for a network event?
> > 
> > Because the application that needs to handle the network packet is 
> > currently blocked trying to draw something to the screen.
> 
> Then that's an application bug right there, isn't it?
> 
> If should have listened to the window server telling its clients it was
> going to go away. Drawing after you get that is your own damn fault ;-)

How long do you wait for applications to respond that they've stopped 
drawing? What if the application is heavily in swap at the time?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
