Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2DLFLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:11:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:20652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2DLFLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="128116084"
Message-ID: <4F8663B3.9060900@intel.com>
Date: Thu, 12 Apr 2012 13:10:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Alex Shi <lkml.alex@gmail.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        tglx@linutronix.de, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [tip:timers/urgent] clockevents: tTack broadcast device mode
 change in tick_broadcast_switch_to_oneshot()
References: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>  <tip-fa4da365bc7772c2cd6d5405bdf151612455f957@git.kernel.org>  <CAGjg+kFqZ2g4GV8r-NLujMVP7p9W2vUNZszxEFVs6eohSFv_PA@mail.gmail.com> <1334205354.2583.1.camel@sbsiddha-mobl2>
In-Reply-To: <1334205354.2583.1.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 12:35 PM, Suresh Siddha wrote:

> On Thu, 2012-04-12 at 09:27 +0800, Alex Shi wrote:
>> This patch recovered the loopback netperf testing on NHM machine, but
>> on SNB machine, It isn't need a broadcost timer at all.
>>
>> Do you think it is better to remove oneshot broadcast on WSM/SNB machine?
> 
> on WSM/SNB, we already don't use broadcast timer and always use
> apictimer instead.


Yes, you are right. I omitted this.

Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
...
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


> 
> thanks,
> suresh
> 


