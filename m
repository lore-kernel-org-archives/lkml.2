Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0ELKwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:52:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23747 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0ELKwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:52:17 -0400
Date: Wed, 12 May 2010 12:52:44 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343AC0@VSHINMSMBX01.vshodc.lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <op.vck9t6il7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck63vc77p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABD@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck8y0uv7p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343AC0@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If luns allocation fails, common->luns will be NULL and freeing a NULL
>> pointer is a no-operation thus the code works just fine.

On Wed, 12 May 2010 12:37:38 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> Oh, okie.
> This was new to me. Sorry for the noise.

Not a problem.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
