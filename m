Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1HQTDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1HQTDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:03:10 -0400
Message-ID: <4E4C11AD.5030603@redhat.com>
Date: Wed, 17 Aug 2011 15:08:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: fix __page_to_pfn for a const struct page argument
References: <1313599233-16595-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1313599233-16595-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 12:40 PM, Ian Campbell wrote:
> This allows the cast in lowmem_page_address (introduced as a warning fixup to
> 33dd4e0ec911 "mm: make some struct page's const") to be removed.
>
> Propagate const'ness to page_to_section() as well since it is required by
> __page_to_pfn.
>
> Signed-off-by: Ian Campbell<ian.campbell@citrix.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Michel Lespinasse<walken@google.com>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Linus Torvalds<torvalds@linux-foundation.org>

Acked-by: Rik van Riel <riel@redhat.com>
