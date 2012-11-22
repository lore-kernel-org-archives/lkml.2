Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab2KVUrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:47:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53234 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KVUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:47:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121121200144.GD15213@quad.lixom.net>
References: <CAHTX3d+bqMnsWxQp3GAmprSDzNB18otT3SrPi5MkA+d8006Aww@mail.gmail.com>
	<20121121200144.GD15213@quad.lixom.net>
Date: Thu, 22 Nov 2012 08:05:48 +0100
X-Google-Sender-Auth: qjQmDEK1cITLciigjCgkzHkqaL4
Message-ID: <CAHTX3dKm_=VaL=14vRr6+jGO2wrDXfW1asjXuZz0yeO0axZnbw@mail.gmail.com>
Subject: Re: [GIT PULL] arm-soc: Xilinx zynq multiplatform changes for v3.8
From: Michal Simek <michal.simek@xilinx.com>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/11/21 Olof Johansson <olof@lixom.net>:
> Hi,
>
> On Wed, Nov 21, 2012 at 04:51:07PM +0100, Michal Simek wrote:
>> Hi Olof and Arnd,
>>
>> based on my chat with Olof today I have created new branch
>> with 4 patches which move zynq to multiplatform.
>>
>> This branch depends on arm-soc devel/debug_ll_init branch because
>> we needed Rob's "ARM: implement debug_ll_io_init()"
>> (sha1: afaee03511ba8002b26a9c6b1fe7d6baf33eac86)
>> patch.
>>
>> This branch also depends on zynq/dt branch because of previous major
>> zynq changes.
>> zynq/cleanup branch is subset of zynq/dt.
>>
>> That's why I have merged devel/debug_ll_init branch with zynq/dt and
>> add 4 patches
>> on the top of it.
>
> Nice work.
>
> This looks quite reasonable, is small and self-contained and doesn't really
> affect anyone outside of zynq. So I've pulled into next/multiplatform for 3.8.
>
> As part of this, the next/* branches have been somewhat reordered, since
> multiplatform now includes next/dt contents I've moved it down below there. It
> shouldn't affect much since no other branch pulls in next/multiplatform
> contents.

Thanks a lot,
Michal
