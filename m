Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1LTQEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:04:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1LTQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:04:26 -0500
Message-ID: <4EF0B1FA.20209@redhat.com>
Date: Tue, 20 Dec 2011 11:04:10 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] consider swap space when we decide compaction goes or
 not
References: <1324363653-18220-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1324363653-18220-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 01:47 AM, Minchan Kim wrote:
> It's pointless to go reclaiming when we have no swap space
> and lots of anon pages in inactive list.
>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Johannes Weiner<jweiner@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Signed-off-by: Minchan Kim<minchan@kernel.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
