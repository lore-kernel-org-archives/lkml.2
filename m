Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2BHStA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:49:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab2BHSs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:48:56 -0500
Message-ID: <4F32C35F.1090806@redhat.com>
Date: Wed, 08 Feb 2012 13:47:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 01/15] mm: Serialize access to min_free_kbytes
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1328568978-17553-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 05:56 PM, Mel Gorman wrote:
> There is a race between the min_free_kbytes sysctl, memory hotplug
> and transparent hugepage support enablement.  Memory hotplug uses a
> zonelists_mutex to avoid a race when building zonelists. Reuse it to
> serialise watermark updates.
>
> [a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

