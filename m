Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2IMXNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:13:46 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57565 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2IMXNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:13:45 -0400
Date: Thu, 13 Sep 2012 19:13:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] enable CONFIG_COMPACTION by default
Message-ID: <20120913231335.GA1569@cmpxchg.org>
References: <20120913162104.1458bea2@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913162104.1458bea2@cuia.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:21:04PM -0400, Rik van Riel wrote:
> Now that lumpy reclaim has been removed, compaction is the
> only way left to free up contiguous memory areas. It is time
> to just enable CONFIG_COMPACTION by default.
>     
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
