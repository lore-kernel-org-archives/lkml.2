Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0GUUmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:42:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11325 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0GUUmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:42:15 -0400
Date: Wed, 21 Jul 2010 22:43:37 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <1279744472.31376.42.camel@c-dwalke-linux.qualcomm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Message-id: <op.vf7nuzu57p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
 <op.vf5o28st7p4s8u@pikus>
 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
 <op.vf6zo9vb7p4s8u@pikus>
 <1279733750.31376.14.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7gt3qy7p4s8u@pikus>
 <1279736348.31376.20.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7h1yc47p4s8u@pikus>
 <1279738688.31376.24.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7j13067p4s8u@pikus>
 <1279741029.31376.33.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7lipj67p4s8u@pikus>
 <1279742604.31376.40.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7mvhvn7p4s8u@pikus>
 <1279744472.31376.42.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-07-21 at 22:22 +0200, Michał Nazarewicz wrote:
>> Right.....  Please show me a place where I've written that it won't be in
>> the kernel? I keep repeating command line is only one of the possibilities.
>> I would imagine that in final product defaults from platform would be used
>> and bootloader would be left alone.

On Wed, 21 Jul 2010 22:34:32 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:
> It should never be anyplace else.

I disagree.  There are countless “dubug_level” kernel parameters or even
some “printk” related parameters.  Those are completely hardware-independent.
There are also parameters that are hardware dependent but most users won't
care to set them.  That's how the things are: there are some defaults but
you can override them by command line parameters.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
