Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0H0CmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:42:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65508 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0H0CmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:42:11 -0400
Date: Fri, 27 Aug 2010 04:41:36 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
In-reply-to: <1282810627.1975.237.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <p.osciak@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vh2sfmqt7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop> <op.vh0ud3rg7p4s8u@localhost>
 <1282810627.1975.237.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 10:17:07 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> So why not work on the page allocator to improve its contiguous
> allocation behaviour. If you look at the thing you'll find pageblocks
> and migration types. If you change it so that you pin the migration type
> of one or a number of contiguous pageblocks to say MIGRATE_MOVABLE, so
> that they cannot be used for anything but movable pages you're pretty
> much there.

And that's exactly where I'm headed.  I've created API that seems to be
usable and meat mine and others requirements (not that I'm not saying it
cannot be improved -- I'm always happy to hear comments) and now I'm
starting to concentrate on the reusing of the grabbed memory.  At first
I wasn't sure how this can be managed but thanks to many comments
(including yours, thanks!) I have an idea of how the thing should work
and what I should do from now.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

