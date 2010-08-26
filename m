Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0HZBWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:22:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48669 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0HZBWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:22:03 -0400
Date: Thu, 26 Aug 2010 03:20:57 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 3/6] mm: cma: Added SysFS support
In-reply-to: <20100825203707.GB5318@phenom.dumpdata.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Pawel Osciak <p.osciak@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vh0t07om7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <0b02e05fc21e70a3af39e65e628d117cd89d70a1.1282286941.git.m.nazarewicz@samsung.com>
 <343f4b0edf9b5eef598831700cb459cd428d3f2e.1282286941.git.m.nazarewicz@samsung.com>
 <9883433f103cc84e55db150806d2270200c74c6b.1282286941.git.m.nazarewicz@samsung.com>
 <20100825203707.GB5318@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 22:37:08 +0200, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Whats the rationale for having those #ifdef CONFIG_CMA_SYSFS sprinkled
> in the C code? Is SysFS not used on StrongARM? Why not implicitly include
> the SysFS support?

The SysFS CMA interface is meant for development only and because of that
I decided to separate it form the core in a separate patch and enable it
only when explicitly requested.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

