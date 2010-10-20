Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998Ab0JTNAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:00:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35937 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JTNAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:00:44 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <8739s2xfuk.fsf@deeprootsystems.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-2-git-send-email-ohad@wizery.com> <8739s2xfuk.fsf@deeprootsystems.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 20 Oct 2010 15:00:22 +0200
Message-ID: <AANLkTinHOOPfke2dJrQ1=+vzsa=0BSQjkX5ai7mwpcF8@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 7:16 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Ohad Ben-Cohen <ohad@wizery.com> writes:
>
>> From: Simon Que <sque@ti.com>
>>
>> Add driver for OMAP's Hardware Spinlock module.
>>
>> The OMAP Hardware Spinlock module, initially introduced in OMAP4,
>> provides hardware assistance for synchronization between the
>> multiple processors in the device (Cortex-A9, Cortex-M3 and
>> C64x+ DSP).
>
...

>> +config OMAP_HWSPINLOCK
>> +     bool "OMAP Hardware Spinlock module"
>
> Should be tristate

Agree,

> so it can also be built as a module by default.
>
> e.g., when building multi-OMAP kernels, no reason or this to be
> built-in.  It can then be loaded as a module on OMAP4 only.

But considering the current built-in use cases (i2c) we would then
need to have the relevant MACH_OMAP4_* select OMAP_HWSPINLOCK (only on
the OMAP4 machines on which the I2C bus is shared).


>
> Kevin
>
