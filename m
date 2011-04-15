Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1DONX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1DONX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:23:26 -0400
Message-ID: <4DA846BF.7020504@redhat.com>
Date: Fri, 15 Apr 2011 09:23:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        raz ben yehuda <raziebe@gmail.com>, kosaki.motohiro@jp.fujitsu.com,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@kernel.org
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
References: <20110415101248.GB22688@suse.de>
In-Reply-To: <20110415101248.GB22688@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 06:12 AM, Mel Gorman wrote:

> This patch simply re-adds the check normally done by pte_alloc_map to
> check if the PTE needs to be allocated before taking the page table
> lock. The effect is noticable in page_test from aim9.

> Reported-by: Raz Ben Yehuda<raziebe@gmail.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
