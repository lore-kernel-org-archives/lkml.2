Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0IGB7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:59:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28931 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0IGB7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:59:34 -0400
Date: Tue, 07 Sep 2010 03:58:50 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [RFCv5 8/9] mm: vcm: Sample driver added
In-reply-to: <20100906211054.GC5863@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Peter Zijlstra <peterz@infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vim3scj57p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1283749231.git.mina86@mina86.com>
 <262a5a5019c1f1a44d5793f7e69776e56f27af06.1283749231.git.mina86@mina86.com>
 <20100906211054.GC5863@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010 23:10:54 +0200, Greg KH <greg@kroah.com> wrote:

> On Mon, Sep 06, 2010 at 08:33:58AM +0200, Michal Nazarewicz wrote:
>> --- /dev/null
>> +++ b/include/linux/vcm-sample.h
>
> Don't put "sample" code in include/linux/ please.  That's just
> cluttering up the place, don't you think?  Especially as no one else
> needs the file there...

Absolutely true.  My plan is to put a real driver in place of the sample
driver and post it with v6.  For now I just wanted to put a piece of code
that will look like a driver for presentation purposes.  Sorry for the
confusion.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

