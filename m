Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab1LPEbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab1LPEbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:31:36 -0500
Message-ID: <4EEAC988.80803@redhat.com>
Date: Thu, 15 Dec 2011 23:31:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/11] mm: compaction: Introduce sync-light migration
 for use by compaction
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-9-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-9-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
> mode that avoids writing back pages to backing storage. Async
> compaction maps to MIGRATE_ASYNC while sync compaction maps to
> MIGRATE_SYNC_LIGHT. For other migrate_pages users such as memory
> hotplug, MIGRATE_SYNC is used.
>
> This avoids sync compaction stalling for an excessive length of time,
> particularly when copying files to a USB stick where there might be
> a large number of dirty pages backed by a filesystem that does not
> support ->writepages.
>
> [aarcange@redhat.com: This patch is heavily based on Andrea's work]
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
