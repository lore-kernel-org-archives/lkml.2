Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab0E0VG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:06:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52355 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0E0VG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:06:28 -0400
Date: Thu, 27 May 2010 22:06:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527210609.GA8865@srcf.ucam.org>
References: <20100527172510.GC2468@srcf.ucam.org> <1274981288.27810.5609.camel@twins> <20100527173218.GF2468@srcf.ucam.org> <1274981750.27810.5641.camel@twins> <20100527174140.GB3187@srcf.ucam.org> <1274982397.27810.5679.camel@twins> <20100527175258.GB3543@srcf.ucam.org> <1274982981.27810.5719.camel@twins> <20100527175920.GE3543@srcf.ucam.org> <20100527220314.312d9e3c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527220314.312d9e3c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:03:14PM +0100, Alan Cox wrote:
> On Thu, 27 May 2010 18:59:20 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Ok. So the existing badly-behaved application ignores your request and 
> > then gets blocked. And now it no longer responds to wakeup events. So 
> > you penalise well-behaved applications without providing any benefits to 
> > badly-behaved ones.
> 
> I don't see how you put the first two sentences together and get the
> final one.
> 
> When you beat up badly behaved apps that doesn't penalise well behaved
> ones.

If you're going to block an app on drawing then you either need to 
reenable drawing on wakeup or you need to have an interface for alerting 
the app to the fact that drawing is about to block and it should get 
back to its event loop. The first is suboptimal, the second penalises 
well behaved apps.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
