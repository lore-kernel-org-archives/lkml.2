Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2BFMqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:46:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46711 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2BFMqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:46:53 -0500
MIME-Version: 1.0
In-Reply-To: <op.v87mrdg83l0zgt@mpn-glaptop>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
	<1328271538-14502-6-git-send-email-m.szyprowski@samsung.com>
	<CAJd=RBBsTxV4bM_QEbKaU=uKkFTNgPEK4yTiLjbE0TaEp4KA7w@mail.gmail.com>
	<op.v87mrdg83l0zgt@mpn-glaptop>
Date: Mon, 6 Feb 2012 20:46:51 +0800
Message-ID: <CAJd=RBAsRA-yggVSmijJPTLM2kKiLKWrTS9RjtESgPDc3pYTug@mail.gmail.com>
Subject: Re: [PATCH 05/15] mm: compaction: export some of the functions
From: Hillf Danton <dhillf@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/5 Michal Nazarewicz <mina86@mina86.com>:
>> On Fri, Feb 3, 2012 at 8:18 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>>>
>>> From: Michal Nazarewicz <mina86@mina86.com>
>>>
>>> This commit exports some of the functions from compaction.c file
>>> outside of it adding their declaration into internal.h header
>>> file so that other mm related code can use them.
>>>
>>> This forced compaction.c to always be compiled (as opposed to being
>>> compiled only if CONFIG_COMPACTION is defined) but as to avoid
>>> introducing code that user did not ask for, part of the compaction.c
>>> is now wrapped in on #ifdef.
>
>
> On Sun, 05 Feb 2012 08:40:08 +0100, Hillf Danton <dhillf@gmail.com> wrote:
>>
>> What if both compaction and CMA are not enabled?
>
>
> What about it?  If both are enabled, both will be compiled and usable.
>

Better if enforced compilation of compaction is addressed in separate
patch in the patchset, according to the rule that one patch is delivered
with one issue concerned.
