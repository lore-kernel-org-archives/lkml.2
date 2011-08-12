Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1HLNd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:33:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1HLNdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:33:53 -0400
Date: Fri, 12 Aug 2011 15:33:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 2/2] mm: vmscan: drop nr_force_scan[] from get_scan_count
Message-ID: <20110812133352.GD32335@tiehlicka.suse.cz>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
 <1313094715-31187-2-git-send-email-jweiner@redhat.com>
 <CAEwNFnBp7JBWpuaT=ZKDyfQTQqOe_mT0CLFAw9LWo10GoXaFnQ@mail.gmail.com>
 <20110812065858.GA6916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812065858.GA6916@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-08-11 08:58:58, Johannes Weiner wrote:
[...]
> From: Johannes Weiner <jweiner@redhat.com>
> Subject: [patch] mm: vmscan: drop nr_force_scan[] from get_scan_count
> 
> The nr_force_scan[] tuple holds the effective scan numbers for anon
> and file pages in case the situation called for a forced scan and the
> regularly calculated scan numbers turned out zero.
> 
> However, the effective scan number can always be assumed to be
> SWAP_CLUSTER_MAX right before the division into anon and file.  The
> numerators and denominator are properly set up for all cases, be it
> force scan for just file, just anon, or both, to do the right thing.

> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Nice. The code is much easier to read.
Reviewed-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
