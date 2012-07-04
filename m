Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2GDHBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:01:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53250 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2GDHBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zGjLgNBHsHF6xmadpsntXBRaOVt58AeOCaawZ-pbQdzQ@mail.gmail.com>
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
 <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com> <CAGsJ_4yjV+HDXdYraJ6CdJrSz1EPGgE6BRvO-_9n+6_UWfxqww@mail.gmail.com>
 <op.wgvfgmm03l0zgt@mpn-glaptop> <000301cd59b1$87094eb0$951bec10$%szyprowski@samsung.com>
 <CAGsJ_4zGjLgNBHsHF6xmadpsntXBRaOVt58AeOCaawZ-pbQdzQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 4 Jul 2012 15:00:40 +0800
Message-ID: <CAGsJ_4w5bL8FU6E59BEBSWGkkU7T8Tr8-KZRV2EUYRR18Vo1TA@mail.gmail.com>
Subject: Re: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, Barry Song <Barry.Song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/4 Barry Song <21cnbao@gmail.com>:
> Hi Marek,
>
> 2012/7/4 Marek Szyprowski <m.szyprowski@samsung.com>:
>> Hello,
>>
>> On Tuesday, July 03, 2012 2:54 PM Michal Nazarewicz wrote:
>>
>>> > 2012/7/3 Marek Szyprowski <m.szyprowski@samsung.com>:
>>> >> IMHO the right place for such code is in drivers/misc instead of tools/cma.
>>> >>
>>> >> This patch contains a kernel module source code so it should be put with other kernel
>>> >> modules. tools/ directory is aimed to contain user space code useful for developing and
>>> >> testing Linux kernel.
>>>
>>> On Tue, 03 Jul 2012 09:39:34 +0200, Barry Song <21cnbao@gmail.com> wrote:
>>> > this one is aiming to test CMA, it should be in tools/ as Michal
>>> > Nazarewicz and i have talked about that.
>>> > it is not a real driver at all.
>>>
>>> Yeah, I feel like it's better placed in tools/ not to pollute other directories with
>>> drivers that are of no use to regular users.  I don't have strong feelings about it
>>> though, so I'm fine either way.
>>
>> Other test devices/drivers are in drivers directory (drivers/usb/misc/usbtest.c for
>> example), I don't see any good reason for polluting tools/ directory with kernel code.
>>
>> IMHO the right person to decide if it makes sense to have such drivers in drivers/mics/
>> or tools/cma/ is Greg KH. Barry, please resend it and ask Greg for the decision.
>
> sure. thanks.

and BTW, if the only issue is the dir it should be placed to let Greg
decide, would i also have your reviewed-by before sending to Greg KH?

>
>>
>> Best regards
>> --
>> Marek Szyprowski
>> Samsung Poland R&D Center
>>

-barry
