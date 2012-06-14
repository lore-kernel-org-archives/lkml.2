Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2FNPCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:02:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59034 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab2FNPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:02:32 -0400
Date: Fri, 15 Jun 2012 00:02:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: fix page reclaim comment error
Message-ID: <20120614150223.GB2097@barrios>
References: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 08:41:02PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since there are five lists in LRU cache, the array nr in get_scan_count
> should be:
> 
> nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
> nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!
 
