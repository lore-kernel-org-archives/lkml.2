Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab0JTGNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:13:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56849 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab0JTGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:13:46 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 20 Oct 2010 08:13:25 +0200
Message-ID: <AANLkTikPnm1NK1wGGzbOuNoCOnAcSp=RC8mTW2yx3u0s@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        mattw@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 1:31 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Mon, 2010-10-18 at 09:44 +0200, Ohad Ben-Cohen wrote:
>> OMAP4 introduces a Spinlock hardware module, which provides hardware
>> assistance for synchronization and mutual exclusion between heterogeneous
>> processors and those not operating under a single, shared operating system
>> (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
>>
>> The intention of this hardware module is to allow remote processors,
>> that have no alternative mechanism to accomplish synchronization and mutual
>> exclusion operations, to share resources (such as memory and/or any other
>> hardware resource).
>>
>> This patchset adds a new misc driver for this OMAP hwspinlock module.
>
> Does this code interface with some hardware unit (other than the other
> processors) to accomplish this locking ?

Yes, it's a special-purpose hardware peripheral.

> The reason I ask is because MSM has similar code, and from what I can
> tell the MSM version has some structures in memory but that's all. It
> just operates on the structures in memory.

That's interesting.

We did have thoughts of making this a generic framework, in the hope
that it would be useful for other vendors too, but we didn't find
additional users.

> It might be worth looking over the two implementation so we aren't both
> remaking the wheel.

Indeed. Where is that MSM code ?

Thanks,
Ohad.
