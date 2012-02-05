Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2BEOhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:37:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2BEOhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:37:15 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Hillf Danton" <dhillf@gmail.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-9-git-send-email-m.szyprowski@samsung.com>
 <CAJd=RBByc_wLEJTK66J4eY03CWnCoCRiwAeEYjXCZ5xEZhp3ag@mail.gmail.com>
 <op.v830ygma3l0zgt@mpn-glaptop>
 <CAJd=RBD765rmiCDiCz87Vf8vf8Wp-AiW=gZ3Nw5LjTPw70ZO7g@mail.gmail.com>
Date: Sun, 05 Feb 2012 15:37:07 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v87mv5ca3l0zgt@mpn-glaptop>
In-Reply-To: <CAJd=RBD765rmiCDiCz87Vf8vf8Wp-AiW=gZ3Nw5LjTPw70ZO7g@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +static inline bool migrate_async_suitable(int migratetype)

>> On Fri, 03 Feb 2012 15:19:54 +0100, Hillf Danton <dhillf@gmail.com> wrote:
>>> Just nitpick, since the helper is not directly related to what async
>>> means, how about migrate_suitable(int migrate_type) ?

> 2012/2/3 Michal Nazarewicz <mina86@mina86.com>:
>> I feel current name is better suited since it says that it's OK to scan this
>> block if it's an asynchronous compaction run.

On Sat, 04 Feb 2012 10:09:02 +0100, Hillf Danton <dhillf@gmail.com> wrote:
> The input is the migrate type of page considered, and the async is only one
> of the modes that compaction should be carried out. Plus the helper is
> also used in other cases where async is entirely not concerned.
>
> That said, the naming is not clear, if not misleading.

In the first version the function was called is_migrate_cma_or_movable() which
described what the function checked.  Mel did not like it though, hence the
change to migrate_async_suitable().  Honestly, I'm not sure what would be the
best name for function.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
