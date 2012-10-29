Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2J2CGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:06:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64963 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2J2CGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:06:35 -0400
X-AuditID: 9c930179-b7c8bae000003559-95-508de4a9e6f9
Date: Mon, 29 Oct 2012 11:12:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/5] minor clean-up and optimize highmem related code
Message-ID: <20121029021219.GK15767@bbox>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351451576-2611-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Mon, Oct 29, 2012 at 04:12:51AM +0900, Joonsoo Kim wrote:
> This patchset clean-up and optimize highmem related code.
> 
> [1] is just clean-up and doesn't introduce any functional change.
> [2-3] are for clean-up and optimization.
> These eliminate an useless lock opearation and list management.
> [4-5] is for optimization related to flush_all_zero_pkmaps().
> 
> Joonsoo Kim (5):
>   mm, highmem: use PKMAP_NR() to calculate an index of pkmap
>   mm, highmem: remove useless pool_lock
>   mm, highmem: remove page_address_pool list
>   mm, highmem: makes flush_all_zero_pkmaps() return index of last
>     flushed entry
>   mm, highmem: get virtual address of the page using PKMAP_ADDR()

This patchset looks awesome to me.
If you have a plan to respin, please CCed Peter.

-- 
Kind regards,
Minchan Kim
