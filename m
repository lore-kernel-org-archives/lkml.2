Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab0HENsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:48:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52382 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795Ab0HENs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:48:29 -0400
Date: Thu, 5 Aug 2010 14:47:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805134741.GC20565@srcf.ucam.org>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl> <20100804205654.GA4986@srcf.ucam.org> <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm> <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <20100804231003.GL24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041616160.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008041616160.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:19:20PM -0700, david@lang.hm wrote:

> only consider the activity of a subset of processes when deciding if we  
> should suspend or not. If the decision is to suspend, freeze everything.
>
> you (and many other people) are confusing what I've proposed (use cgroups 
> to indicate what processes to care about and what ones to not care about  
> when deciding to suspend/go to idle) with the prior cgroup proposal (use  
> cgroups to freeze a subset of tasks while leaving others runnable)

The decision on whether or not to go to sleep isn't the difficult bit of 
this problem space.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
