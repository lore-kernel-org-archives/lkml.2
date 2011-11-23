Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1KWUBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:01:55 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42165 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab1KWUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:01:53 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Menon\, Nishanth" <nm@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RESEND #3 1/7] OMAP3+: PM: SR: add suspend/resume handlers
Organization: Texas Instruments, Inc.
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
	<1321346765-16633-2-git-send-email-balbi@ti.com>
	<87vcqj62gd.fsf@ti.com>
	<CAOMWX4egSeBfHdD4LHxtvvaQj+MK0ecRrQGdQ+ELDRUz5tFUEg@mail.gmail.com>
Date: Wed, 23 Nov 2011 12:01:46 -0800
In-Reply-To: <CAOMWX4egSeBfHdD4LHxtvvaQj+MK0ecRrQGdQ+ELDRUz5tFUEg@mail.gmail.com>
	(Nishanth Menon's message of "Fri, 18 Nov 2011 18:35:53 -0600")
Message-ID: <87ty5ua9qt.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Menon, Nishanth" <nm@ti.com> writes:

> On Wed, Nov 16, 2011 at 18:02, Kevin Hilman <khilman@ti.com> wrote:
>> Felipe Balbi <balbi@ti.com> writes:
>>
>>> From: Nishanth Menon <nm@ti.com>
>>>
>>> SmartReflex should be disabled while entering low power mode due to
>>> the following reasons:
>> [...]
>>
>> Nishanth, in the end, didn't you decide to drop this patch?
>>
>
> Yes, I did eventually, once we implemented DVFS for GPU, Ducati, HSI,
> and other drivers, there was no real way to ensure sequence of suspend
> sequencing even after moving this to suspend_noirq. some of the other
> reasons:

OK, thanks for the clarification.

Kevin
