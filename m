Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1JLO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1JLO5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:57:09 -0400
Date: Wed, 12 Oct 2011 10:57:01 -0400
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        akpm@linux-foundation.org, Josh Boyer <jwboyer@redhat.com>,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Abort reclaim/compaction if compaction can
 proceed
Message-ID: <20111012145701.GA6478@redhat.com>
References: <1318000643-27996-1-git-send-email-mgorman@suse.de>
 <1318000643-27996-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318000643-27996-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:17:23PM +0100, Mel Gorman wrote:
> If compaction can proceed, shrink_zones() stops doing any work but
> the callers still shrink_slab(), raises the priority and potentially
> sleeps.  This patch aborts direct reclaim/compaction entirely if
> compaction can proceed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <jweiner@redhat.com>
