Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2A3MdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:33:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42413 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2A3MdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:33:10 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 05/15] mm: compaction: export some of the functions
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-6-git-send-email-m.szyprowski@samsung.com>
 <20120130115726.GI25268@csn.ul.ie>
Date: Mon, 30 Jan 2012 13:33:06 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v8wc5guk3l0zgt@mpn-glaptop>
In-Reply-To: <20120130115726.GI25268@csn.ul.ie>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 26, 2012 at 10:00:47AM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -16,30 +16,11 @@
>>  #include <linux/sysfs.h>
>>  #include "internal.h"
>>
>> +#if defined CONFIG_COMPACTION || defined CONFIG_CMA
>> +

On Mon, 30 Jan 2012 12:57:26 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> This is pedantic but you reference CONFIG_CMA before the patch that
> declares it. The only time this really matters is when it breaks
> bisection but I do not think that is the case here.

I think I'll choose to be lazy on this one. ;) I actually tried to move
some commits around to resolve this future-reference, but this resulted
in quite a few conflicts during rebase and after several minutes I decided
that it's not worth the effort.

> Whether you fix this or not by moving the CONFIG_CMA check to the same
> patch that declares it in Kconfig
>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
