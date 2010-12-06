Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0LFD03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0LFD02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:26:28 -0500
Message-ID: <4CFC57BF.6000903@redhat.com>
Date: Sun, 05 Dec 2010 22:25:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v4 6/7] Remove zap_details NULL dependency
References: <cover.1291568905.git.minchan.kim@gmail.com> <807118ceb3beeccdd69dda8228229e37b49d9803.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <807118ceb3beeccdd69dda8228229e37b49d9803.1291568905.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 12:29 PM, Minchan Kim wrote:
> Some functions used zap_details depends on assumption that
> zap_details parameter should be NULLed if some fields are 0.
>
> This patch removes that dependency for next patch easy review/merge.
> It should not chanage behavior.
>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Nick Piggin<npiggin@kernel.dk>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Cc: Wu Fengguang<fengguang.wu@intel.com>
> Cc: Hugh Dickins<hughd@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
