Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342Ab0HFN3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:29:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15169 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab0HFN32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:29:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 06 Aug 2010 15:31:00 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201008030919.36575.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Zach Pfeffer'" <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vg0qhyki7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <201008011526.13566.hverkuil@xs4all.nl> <op.vgticdzj7p4s8u@pikus>
 <201008030919.36575.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

I've just posted updated patchset.  It changes the way regions are
reserved somehow so our discussion is not entirely applicable to a
new version I think.

I preserved the original "map" there.  I came to a conclusion that
your approach is not that different from what I had in mind but I
noticed that with your syntax it's impossible to specify the order
of regions to try. For instance that driver should first try region
"foo" and then region "bar" and not the other way around.

I'm looking forward to hearing your comments on the newest version
of CMA.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
