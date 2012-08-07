Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2HGNaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab2HGNaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:30:22 -0400
Message-ID: <50211865.90702@redhat.com>
Date: Tue, 07 Aug 2012 09:30:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mm: compaction: Capture a suitable high-order page
 immediately when it is made available
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1344342677-5845-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:31 AM, Mel Gorman wrote:
> While compaction is moving pages to free up large contiguous blocks for
> allocation it races with other allocation requests that may steal these
> blocks or break them up. This patch alters direct compaction to capture a
> suitable free page as soon as it becomes available to reduce this race. It
> uses similar logic to split_free_page() to ensure that watermarks are
> still obeyed.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
