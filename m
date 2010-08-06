Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294Ab0HFWO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:14:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:37092 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934096Ab0HFWO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:14:28 -0400
Date: Fri, 6 Aug 2010 15:12:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: kevin granade <kevin.granade@gmail.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100806172409.GI2432@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008061500060.30564@asgard.lang.hm>
References: <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm> <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com> <alpine.DEB.2.00.1008051312220.23543@asgard.lang.hm> <20100805231936.GS2447@linux.vnet.ibm.com> <alpine.DEB.2.00.1008060111240.30564@asgard.lang.hm>
 <20100806172409.GI2432@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010, Paul E. McKenney wrote:

> On Fri, Aug 06, 2010 at 01:29:57AM -0700, david@lang.hm wrote:
>> On Thu, 5 Aug 2010, Paul E. McKenney wrote:
>>
>>> On Thu, Aug 05, 2010 at 01:26:18PM -0700, david@lang.hm wrote:
>>>> On Thu, 5 Aug 2010, kevin granade wrote:
>>>>
>>>>> On Thu, Aug 5, 2010 at 10:46 AM,  <david@lang.hm> wrote:
>>>>>> On Thu, 5 Aug 2010, Paul E. McKenney wrote:
>>>>>>
>>>>>>> On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
>>>>>>>>
>>>>>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>>>>>>>>
>>>>>>>>> On Wed, Aug 04, 2010 at 05:25:53PM -0700, david@lang.hm wrote:
>>>>>>>>>>
>>>>>>>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
>>>>>>>
>>>>>>> [ . . . ]
>>>>>>>
>>
>> it would be nice to get network traffic/connection stats.
>>
>> so two questions.
>>
>> first, what else would you need to get accumulated for the cgroup
>>
>> second, is there a fairly easy way to have these stats available?
>>
>> for the 'last time it ran' stat, this seems like you could have a
>> per-cpu variable per cgroup that's fairly cheap to update, but you
>> would need to take a global lock to read accuratly (the lock may be
>> expensive enough that it's worth trying to read the variables from
>> the other cpu without a lock, just to see if it's remotely possible
>> to sleep/suspend)
>>
>> with timers, is it possible to have multiple timer wheels (one per
>> cgroup)?
>
> I apologize in advance for what I am about to write, but...
>
> If you continue in this vein, you are likely to make suspend blockers
> look very simple and natural.  ;-)

if that's the case then they should be implemented :-)

on the other hand, this may be something that's desirable for 
idle-low-power as well.

David Lang
