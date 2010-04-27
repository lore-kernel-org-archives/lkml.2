Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0D0AIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0D0AIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:08:50 -0400
Message-ID: <4BD62AE3.2070302@redhat.com>
Date: Mon, 26 Apr 2010 20:08:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm,migration: During fork(), wait for migration to
 end if migration PTE is encountered
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie> <1272321478-28481-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1272321478-28481-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 06:37 PM, Mel Gorman wrote:
> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> At page migration, we replace pte with migration_entry, which has
> similar format as swap_entry and replace it with real pfn at the
> end of migration. But there is a race with fork()'s copy_page_range().

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
