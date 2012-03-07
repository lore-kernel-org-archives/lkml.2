Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab2CGDQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:16:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43151 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab2CGDQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:16:44 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E5D2FF5@HQMAIL01.nvidia.com>
References: <1328288172-8059-1-git-send-email-sjg@chromium.org>
	<74CDBE0F657A3D45AFBB94109FB122FF178E5D2FF5@HQMAIL01.nvidia.com>
Date: Tue, 6 Mar 2012 19:16:43 -0800
X-Google-Sender-Auth: DmRR_k5nS_oBi2JRLop4PDVyLD0
Message-ID: <CAPnjgZ1rXEGbi3m3HeWiUxG_TbmUug0C0QZgb7_9Eiz-xPMHwg@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode / OTG
From: Simon Glass <sjg@chromium.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Olof

Hi,

On Fri, Feb 3, 2012 at 11:59 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Simon Glass wrote at riday, February 03, 2012 9:56 AM:
>> This little series brings in some bindings that seem useful for U-Boot.
>>
>> I am working mostly in U-Boot, but since there is no shared .dts repo
>> I was asked to commit these changes to the kernel. I do not propose to
>> update the Linux USB drivers to match.
>
> I think the series looks reasonable, so:
>
> Acked-by: Stephen Warren <swarren@nvidia.com<>
>
> (I note that the kernel's USB driver for USB1 doesn't attempt to clear
> legacy mode; I wonder how we're getting away with that. Perhaps it's
> only been tested with a bootloader that's already cleared legacy mode)
>

How does this series get picked up, please?

Regards,
Simon

> --
> nvpublic
>
