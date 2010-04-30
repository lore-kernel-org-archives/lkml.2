Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab0D3UWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0D3UWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:22:47 -0400
Message-ID: <4BDB3BDC.2050004@redhat.com>
Date: Fri, 30 Apr 2010 16:21:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <20100429162120.GC22108@random.random> <20100430192235.GL22108@random.random>
In-Reply-To: <20100430192235.GL22108@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 03:22 PM, Andrea Arcangeli wrote:
> I'm building a mergeable THP+memory compaction tree ready for mainline
> merging based on new anon-vma code, so I'm integrating your patch1 and
> this below should be the port of my alternate fix to your patch2 to
> fix the longstanding crash in migrate (not a bug in new anon-vma code
> but longstanding). patch1 is instead about the bugs introduced by the
> new anon-vma code that might crash migrate (even without memory
> compaction and/or THP) the same way as the bug fixed by the below.
>
> ==
> Subject: fix race between shift_arg_pages and rmap_walk
>
> From: Andrea Arcangeli<aarcange@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
