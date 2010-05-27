Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0E0SbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:31:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42904 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0E0SbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:31:17 -0400
Date: Thu, 27 May 2010 19:31:00 +0100
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
Message-ID: <20100527183100.GP3543@srcf.ucam.org>
References: <20100527173218.GF2468@srcf.ucam.org> <1274981750.27810.5641.camel@twins> <20100527174140.GB3187@srcf.ucam.org> <1274982397.27810.5679.camel@twins> <20100527175258.GB3543@srcf.ucam.org> <1274982981.27810.5719.camel@twins> <20100527175920.GE3543@srcf.ucam.org> <1274983598.27810.5761.camel@twins> <20100527181758.GJ3543@srcf.ucam.org> <1274984528.27810.5818.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274984528.27810.5818.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:22:08PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 19:17 +0100, Matthew Garrett wrote:
> 
> > It's blocked on the screen being turned off. It's supposed to be reading 
> > a network packet. How does it ever get to reading the network packet?
> 
> Its blocked because its a buggy app, who cares about misbehaviour in a
> buggy app?

So why bother blocking? Just kill the app and tell the user. If you want 
to support suboptimal apps then blocking isn't sufficient. If you don't 
want to then blocking isn't necessary.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
