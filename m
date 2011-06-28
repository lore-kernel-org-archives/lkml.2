Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1F1XX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:23:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60635 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1F1XXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <1308926697-22475-4-git-send-email-mgorman@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
	<1308926697-22475-4-git-send-email-mgorman@suse.de>
Date: Wed, 29 Jun 2011 08:23:20 +0900
Message-ID: <BANLkTini5rmyX_7wnAx8SA4Zw-wn21K9GQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: vmscan: Evaluate the watermarks against the
 correct classzone
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 11:44 PM, Mel Gorman <mgorman@suse.de> wrote:
> When deciding if kswapd is sleeping prematurely, the classzone is
> taken into account but this is different to what balance_pgdat() and
> the allocator are doing. Specifically, the DMA zone will be checked
> based on the classzone used when waking kswapd which could be for a
> GFP_KERNEL or GFP_HIGHMEM request. The lowmem reserve limit kicks in,
> the watermark is not met and kswapd thinks its sleeping prematurely
> keeping kswapd awake in error.
>
> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
