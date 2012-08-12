Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2HLXM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 19:12:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62336 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2HLXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 19:12:27 -0400
X-AuditID: 9c93016f-b7c98ae0000013b4-a0-502838596679
Date: Mon, 13 Aug 2012 08:14:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v7 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120812231420.GH21033@bbox>
References: <cover.1344619987.git.aquini@redhat.com>
 <292b1b52e863a05b299f94bda69a61371011ac19.1344619987.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292b1b52e863a05b299f94bda69a61371011ac19.1344619987.git.aquini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 02:55:14PM -0300, Rafael Aquini wrote:
> Memory fragmentation introduced by ballooning might reduce significantly
> the number of 2MB contiguous memory blocks that can be used within a guest,
> thus imposing performance penalties associated with the reduced number of
> transparent huge pages that could be used by the guest workload.
> 
> This patch introduces the helper functions as well as the necessary changes
> to teach compaction and migration bits how to cope with pages which are
> part of a guest memory balloon, in order to make them movable by memory
> compaction procedures.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
