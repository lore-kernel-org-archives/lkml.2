Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1KASHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:07:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1KASHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:07:01 -0400
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
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
References: <20111018122109.GB6660@csn.ul.ie>
 <809d0a2afe624c06505e0df51e7657f66aaf9007.1319428526.git.mina86@mina86.com>
 <20111101150448.GD14998@csn.ul.ie>
Date: Tue, 01 Nov 2011 19:06:56 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v394luhl3l0zgt@mpn-glaptop>
In-Reply-To: <20111101150448.GD14998@csn.ul.ie>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Nov 2011 16:04:48 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> For the purposes of review, have a separate patch for moving
> isolate_freepages_block to another file that does not alter the
> function in any way. When the function is updated in a follow-on patch,
> it'll be far easier to see what has changed.

Will do.

> page_isolation.c may also be a better fit than page_alloc.c

Since isolate_freepages_block() is the only user of split_free_page(),
would it make sense to move split_free_page() to page_isolation.c as
well?  I sort of like the idea of making it static and removing from
header file.

> I confess I didn't read closely because of the mess in page_alloc.c but
> the intent seems fine.

No worries.  I just needed for a quick comment whether I'm headed the right
direction. :)

> Hopefully there will be a new version of CMA posted that will be easier
> to review.

I'll try and create the code no latter then on the weekend so hopefully
the new version will be sent next week.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
