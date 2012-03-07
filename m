Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2CGFGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:06:13 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64397 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2CGFGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:06:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMjXkFOxfp9fnhwKFZSoUJmHObk7FaiaNNj2NSyyNMTjkw@mail.gmail.com>
References: <1328288172-8059-1-git-send-email-sjg@chromium.org>
	<74CDBE0F657A3D45AFBB94109FB122FF178E5D2FF5@HQMAIL01.nvidia.com>
	<CAPnjgZ1rXEGbi3m3HeWiUxG_TbmUug0C0QZgb7_9Eiz-xPMHwg@mail.gmail.com>
	<CAOesGMjXkFOxfp9fnhwKFZSoUJmHObk7FaiaNNj2NSyyNMTjkw@mail.gmail.com>
Date: Tue, 6 Mar 2012 21:06:10 -0800
X-Google-Sender-Auth: BEgVH6W0qTSsTqY14IYgkDXdhTo
Message-ID: <CAPnjgZ3gBQyZ3BMesN+2_8ytYEz-0XtYGQwyDL3bUAp+pLoxdw@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode / OTG
From: Simon Glass <sjg@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Tue, Mar 6, 2012 at 8:40 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Mar 6, 2012 at 7:16 PM, Simon Glass <sjg@chromium.org> wrote:
>> +Olof
>>
>> Hi,
>>
>> On Fri, Feb 3, 2012 at 11:59 AM, Stephen Warren <swarren@nvidia.com> wrote:
>>> Simon Glass wrote at riday, February 03, 2012 9:56 AM:
>>>> This little series brings in some bindings that seem useful for U-Boot.
>>>>
>>>> I am working mostly in U-Boot, but since there is no shared .dts repo
>>>> I was asked to commit these changes to the kernel. I do not propose to
>>>> update the Linux USB drivers to match.
>>>
>>> I think the series looks reasonable, so:
>>>
>>> Acked-by: Stephen Warren <swarren@nvidia.com<>
>>>
>>> (I note that the kernel's USB driver for USB1 doesn't attempt to clear
>>> legacy mode; I wonder how we're getting away with that. Perhaps it's
>>> only been tested with a bootloader that's already cleared legacy mode)
>>>
>>
>> How does this series get picked up, please?
>
> It drowned in the patch floods you've been sending, and it wasn't
> addressed directly to me so I ignored it.
>
> Please resend and I'll apply.

You'll be happy to hear that the flood is mostly over now. I have
resent and copied you this time.

Regards,
Simon

>
>
> Thanks,
>
> -Olof
