Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0ETXIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab0ETXIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:08:15 -0400
Message-ID: <4BF5C0B9.9080908@redhat.com>
Date: Thu, 20 May 2010 19:07:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/5] adjust mm_take_all_locks to anon-vma-root locking
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100520224258.GA12100@random.random>
In-Reply-To: <20100520224258.GA12100@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 06:42 PM, Andrea Arcangeli wrote:
> This is needed as 6/5 to avoid lockups in mm_take_all_locks.
>
> ======
> Subject: adjust mm_take_all_locks to the root_anon_vma locking
>
> From: Andrea Arcangeli<aarcange@redhat.com>
>
> Track the anon_vma->root->lock.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
