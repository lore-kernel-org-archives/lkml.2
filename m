Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab2DKSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab2DKSwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:52:45 -0400
Message-ID: <4F85BE78.8040205@redhat.com>
Date: Wed, 11 Apr 2012 13:25:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: vmscan: Remove lumpy reclaim
References: <1334162298-18942-1-git-send-email-mgorman@suse.de> <1334162298-18942-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1334162298-18942-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 12:38 PM, Mel Gorman wrote:
> Lumpy reclaim had a purpose but in the mind of some, it was to kick
> the system so hard it trashed. For others the purpose was to complicate
> vmscan.c. Over time it was giving softer shoes and a nicer attitude but
> memory compaction needs to step up and replace it so this patch sends
> lumpy reclaim to the farm.
>
> The tracepoint format changes for isolating LRU pages with this patch
> applied. Furthermore reclaim/compaction can no longer queue dirty pages in
> pageout() if the underlying BDI is congested. Lumpy reclaim used this logic
> and reclaim/compaction was using it in error.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

