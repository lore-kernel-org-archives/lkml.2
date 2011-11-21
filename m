Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab1KUVrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab1KUVrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:47:09 -0500
Message-ID: <4ECAC6C0.3090202@redhat.com>
Date: Mon, 21 Nov 2011 16:46:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm: compaction: Use synchronous compaction for /proc/sys/vm/compact_memory
References: <1321635524-8586-1-git-send-email-mgorman@suse.de> <1321635524-8586-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1321635524-8586-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:58 AM, Mel Gorman wrote:
> When asynchronous compaction was introduced, the
> /proc/sys/vm/compact_memory handler should have been updated to always
> use synchronous compaction. This did not happen so this patch addresses
> it. The assumption is if a user writes to /proc/sys/vm/compact_memory,
> they are willing for that process to stall.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

