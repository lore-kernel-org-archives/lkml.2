Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886Ab2D0K3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:29:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231Ab2D0K27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:28:59 -0400
Date: Fri, 27 Apr 2012 11:28:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/12] mm/vmscan: remove update_isolated_counts()
Message-ID: <20120427102855.GJ15299@suse.de>
References: <20120426075408.18961.80580.stgit@zurg>
 <20120426131743.9008.52231.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120426131743.9008.52231.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 05:17:43PM +0400, Konstantin Khlebnikov wrote:
> update_isolated_counts() no longer required, because lumpy-reclaim was removed.
> Insanity is over, now here only one kind of inactive pages.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

I should have spotted that. Thanks.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
