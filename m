Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1H3Rwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab1H3Rwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:52:32 -0400
Message-ID: <4E5D2336.50506@redhat.com>
Date: Tue, 30 Aug 2011 13:51:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 1/3] Correct isolate_mode_t bitwise type
References: <cover.1321112552.git.minchan.kim@gmail.com> <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
In-Reply-To: <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2011 11:37 AM, Minchan Kim wrote:
> [c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
> made a mistake on the bitwise type.
>
> This patch corrects it.
>
> CC: Mel Gorman<mgorman@suse.de>
> CC: Johannes Weiner<jweiner@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
