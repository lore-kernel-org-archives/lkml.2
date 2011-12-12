Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1LLPqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:46:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1LLPqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:46:13 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Mel Gorman" <mel@csn.ul.ie>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/11] mm: compaction: export some of the functions
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-5-git-send-email-m.szyprowski@samsung.com>
 <20111212142906.GE3277@csn.ul.ie> <op.v6dseqji3l0zgt@mpn-glaptop>
 <20111212154015.GI3277@csn.ul.ie>
Date: Mon, 12 Dec 2011 16:46:10 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6dve8mo3l0zgt@mpn-glaptop>
In-Reply-To: <20111212154015.GI3277@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Mon, 12 Dec 2011 15:29:07 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
>>> Overall, this patch implies that CMA is always compiled in.

> On Mon, Dec 12, 2011 at 03:41:04PM +0100, Michal Nazarewicz wrote:
>> Not really.  But yes, it produces some bloat when neither CMA nor
>> compaction are compiled.  I assume that linker will be able to deal
>> with that (since the functions are not EXPORT_SYMBOL'ed).

On Mon, 12 Dec 2011 16:40:15 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> The bloat exists either way. I don't believe the linker strips it out so
> overall it would make more sense to depend on compaction to keep the
> vmstat counters for debugging reasons if nothing else. It's not
> something I feel very strongly about though.

KK, I'll do that then.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
