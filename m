Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2BDJJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 04:09:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62197 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2BDJJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 04:09:03 -0500
MIME-Version: 1.0
In-Reply-To: <op.v830ygma3l0zgt@mpn-glaptop>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
	<1328271538-14502-9-git-send-email-m.szyprowski@samsung.com>
	<CAJd=RBByc_wLEJTK66J4eY03CWnCoCRiwAeEYjXCZ5xEZhp3ag@mail.gmail.com>
	<op.v830ygma3l0zgt@mpn-glaptop>
Date: Sat, 4 Feb 2012 17:09:02 +0800
Message-ID: <CAJd=RBD765rmiCDiCz87Vf8vf8Wp-AiW=gZ3Nw5LjTPw70ZO7g@mail.gmail.com>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/3 Michal Nazarewicz <mina86@mina86.com>:
>>> +static inline bool migrate_async_suitable(int migratetype)
>
> On Fri, 03 Feb 2012 15:19:54 +0100, Hillf Danton <dhillf@gmail.com> wrote:
>>
>> Just nitpick, since the helper is not directly related to what async
>> means,
>> how about migrate_suitable(int migrate_type) ?
>
>
> I feel current name is better suited since it says that it's OK to scan this
> block if it's an asynchronous compaction run.
>

The input is the migrate type of page considered, and the async is only one
of the modes that compaction should be carried out. Plus the helper is
also used in other cases where async is entirely not concerned.

That said, the naming is not clear, if not misleading.
