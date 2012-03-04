Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2CDHLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 02:11:40 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54936 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2CDHLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 02:11:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minchan.kim@gmail.com designates 10.68.228.103 as permitted sender) smtp.mail=minchan.kim@gmail.com; dkim=pass header.i=minchan.kim@gmail.com
Date: Sun, 4 Mar 2012 16:11:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't set __GFP_WRITE on ramfs/sysfs writes
Message-ID: <20120304071129.GB7824@barrios>
References: <20120302061035.GA2344@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302061035.GA2344@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 02:10:35PM +0800, Fengguang Wu wrote:
> There is not much of a point in skipping zones during allocation based
> on the dirty usage which they'll never contribute to. And we'd like to
> avoid page reclaim waits when writing to ramfs/sysfs etc.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Minchan Kim <minchan@kernel.org>

