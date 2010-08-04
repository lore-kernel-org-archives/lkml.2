Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab0HDXyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:54:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:48631 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560Ab0HDXyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:54:31 -0400
Date: Wed, 4 Aug 2010 16:53:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008050133.01169.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1008041650470.6545@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804231003.GL24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041616160.6545@asgard.lang.hm> <201008050133.01169.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Rafael J. Wysocki wrote:

> On Thursday, August 05, 2010, david@lang.hm wrote:
>>
>> My proposal would never freeze a subset of processes.
>>
>> what my proposal:
>>
>> only consider the activity of a subset of processes when deciding if we
>> should suspend or not. If the decision is to suspend, freeze everything.
>
> That alone doesn't allow you to handle the race Matthew was referring to
> (ie. wakeup event happening right after you've decided to suspend).
>
> A mechanism of making a decision alone is not sufficient, you also need a
> mechanism to avoid races between wakeup events and suspend process.
>

I thought you just posted that there was a new feature that would be able 
to abort the suspend and so that race was closed.

David Lang
