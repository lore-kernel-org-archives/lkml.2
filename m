Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1HaPDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1HaPDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:03:41 -0400
Date: Wed, 31 Aug 2011 17:03:00 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/3] compaction accouting fix
Message-ID: <20110831150300.GC19122@redhat.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <282a4531f23c5e35cfddf089f93559130b4bb660.1321112552.git.minchan.kim@gmail.com>
 <20110831113710.GC17512@redhat.com>
 <20110831145651.GA2198@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831145651.GA2198@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 11:56:51PM +0900, Minchan Kim wrote:
> On Wed, Aug 31, 2011 at 01:37:10PM +0200, Johannes Weiner wrote:
> > It's a teensy-bit awkward that isolate_migratepages() can return
> > success without actually isolating any new pages, just because there
> > are still some pages left from a previous run (cc->nr_migratepages is
> > maintained across isolation calls).
> 
> If migrate_pages fails, we reset cc->nr_migratepages to zero in compact_zone.
> Am I missing something?

Brainfart on my side, sorry.  It's all good, then :)
