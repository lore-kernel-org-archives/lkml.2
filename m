Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab0HLCCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 22:02:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51499 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932Ab0HLCCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 22:02:21 -0400
Message-ID: <4C635624.1090407@ti.com>
Date: Wed, 11 Aug 2010 21:02:12 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "Que, Simon" <sque@ti.com>, LKML <linux-kernel@vger.kernel.org>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        Linux Omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>
Subject: linux hardware spinlock framework for heterogeneous processor SOCs?
References: <1279558221-14954-1-git-send-email-h-kanigeri2@ti.com> <1279558221-14954-4-git-send-email-h-kanigeri2@ti.com> <4C518AC0.6070809@ti.com> <F39349C6FA641B4A831B7BF4EBF4D4E1480D9D14@dlee03.ent.ti.com>
In-Reply-To: <F39349C6FA641B4A831B7BF4EBF4D4E1480D9D14@dlee03.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing subject, the original thread is at [1], looping in lkml for a 
wider audience for advice.

Que, Simon had written, on 08/11/2010 05:03 PM, the following:
>> just a curious question:
>>
>> Is there no h/w spinlock implementation for other architectures in
>> linux? I mean the concept does not seem unique for a heterogenous
>> processor environments now a days.. if it does exist, maybe we have two
>> options:
>> * extend standard spinlock architecture to handle h/w spinlocks as well
>> * establish a new framework for h/w spinlocks..
>>
> 
> Thank you for bringing that to my attention.  I did a quick search and
 > haven't found any hwspinlock module elsewhere.  But should there be
 > hwspinlocks over multiple architectures in the future, we can definitely
 > consider something like the two solutions that you suggested, so that
 > they can be used from platform-independent kernel code.  However, right
 > now we can develop OMAP hwspinlock independently of that.

I did glance through the kernel commit log, and nothing remotely seems 
to match up at least in my opinion (closest seemed to be [2] 
drivers/gpu/drm/ - but it did not seem relevant here). If this concept 
is unique to OMAP family alone, then I guess it makes sense to introduce 
SOC specific API library for usage. hoping for some suggestions to 
enlighten us.

Ref:
[1] http://marc.info/?t=127955774200003&r=1&w=2
[2] http://dri.sourceforge.net/doc/hardware_locking_low_level.html

-- 
Regards,
Nishanth Menon
