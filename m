Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507Ab0HEOJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:09:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:53883 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256Ab0HEOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:09:11 -0400
Date: Thu, 5 Aug 2010 07:07:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100805134741.GC20565@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008050706170.25170@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm> <20100804185520.GA2417@srcf.ucam.org> <201008042251.08266.rjw@sisk.pl> <20100804205654.GA4986@srcf.ucam.org> <alpine.DEB.2.00.1008041529530.6545@asgard.lang.hm>
 <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <20100804231003.GL24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041616160.6545@asgard.lang.hm> <20100805134741.GC20565@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 04:19:20PM -0700, david@lang.hm wrote:
>
>> only consider the activity of a subset of processes when deciding if we
>> should suspend or not. If the decision is to suspend, freeze everything.
>>
>> you (and many other people) are confusing what I've proposed (use cgroups
>> to indicate what processes to care about and what ones to not care about
>> when deciding to suspend/go to idle) with the prior cgroup proposal (use
>> cgroups to freeze a subset of tasks while leaving others runnable)
>
> The decision on whether or not to go to sleep isn't the difficult bit of
> this problem space.

but isn't that all that wakelocks do? affect the decision on whether or 
not to go to sleep.

David Lang
