Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab0HEOd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:33:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47299 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab0HEOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:33:26 -0400
Date: Thu, 5 Aug 2010 15:33:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805143302.GA21938@srcf.ucam.org>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804205654.GA4986@srcf.ucam.org> <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com> <201008050220.51805.rjw@sisk.pl> <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com> <20100805134057.GB20565@srcf.ucam.org> <alpine.DEB.2.00.1008050717260.25170@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008050717260.25170@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:22:53AM -0700, david@lang.hm wrote:

> I'm not sure it's possible to completely eliminate the race, even with  
> wakelocks there is some time between the time you last check if the  
> wakelock is set and when the hardware finishes responding to your 
> commands to go to sleep (Unless you can set a level-based interrupt that 
> will wake you up as soon as you finish going to sleep)

It's typically the case that you can - we've even seen that on x86 with 
ACPI GPEs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
