Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab2CGEkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:40:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51649 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2CGEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:40:50 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CAPnjgZ1rXEGbi3m3HeWiUxG_TbmUug0C0QZgb7_9Eiz-xPMHwg@mail.gmail.com>
References: <1328288172-8059-1-git-send-email-sjg@chromium.org>
	<74CDBE0F657A3D45AFBB94109FB122FF178E5D2FF5@HQMAIL01.nvidia.com>
	<CAPnjgZ1rXEGbi3m3HeWiUxG_TbmUug0C0QZgb7_9Eiz-xPMHwg@mail.gmail.com>
Date: Tue, 6 Mar 2012 20:40:49 -0800
Message-ID: <CAOesGMjXkFOxfp9fnhwKFZSoUJmHObk7FaiaNNj2NSyyNMTjkw@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode / OTG
From: Olof Johansson <olof@lixom.net>
To: Simon Glass <sjg@chromium.org>
Cc: Stephen Warren <swarren@nvidia.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:16 PM, Simon Glass <sjg@chromium.org> wrote:
> +Olof
>
> Hi,
>
> On Fri, Feb 3, 2012 at 11:59 AM, Stephen Warren <swarren@nvidia.com> wrote:
>> Simon Glass wrote at riday, February 03, 2012 9:56 AM:
>>> This little series brings in some bindings that seem useful for U-Boot.
>>>
>>> I am working mostly in U-Boot, but since there is no shared .dts repo
>>> I was asked to commit these changes to the kernel. I do not propose to
>>> update the Linux USB drivers to match.
>>
>> I think the series looks reasonable, so:
>>
>> Acked-by: Stephen Warren <swarren@nvidia.com<>
>>
>> (I note that the kernel's USB driver for USB1 doesn't attempt to clear
>> legacy mode; I wonder how we're getting away with that. Perhaps it's
>> only been tested with a bootloader that's already cleared legacy mode)
>>
>
> How does this series get picked up, please?

It drowned in the patch floods you've been sending, and it wasn't
addressed directly to me so I ignored it.

Please resend and I'll apply.


Thanks,

-Olof
