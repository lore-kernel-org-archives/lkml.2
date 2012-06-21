Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab2FUMmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:42:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512Ab2FUMmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:42:39 -0400
Date: Thu, 21 Jun 2012 13:42:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous
 migration
Message-ID: <20120621124235.GN4011@suse.de>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 06:00:12PM -0700, David Rientjes wrote:
> If the range passed to mbind() is not allocated on nodes set in the
> nodemask, it migrates the pages to respect the constraint.
> 
> The final formal of migrate_pages() is a mode of type enum migrate_mode,
> not a boolean.  do_mbind() is currently passing "true" which is the
> equivalent of MIGRATE_SYNC_LIGHT.  This should instead be MIGRATE_SYNC
> for synchronous page migration.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
