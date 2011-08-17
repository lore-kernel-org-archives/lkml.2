Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1HQNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:38:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53172 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1HQNiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:38:17 -0400
Date: Wed, 17 Aug 2011 14:38:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [patch 1/2] mm: vmscan: fix force-scanning small targets without
 swap
Message-ID: <20110817133814.GC4484@csn.ul.ie>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:31:54PM +0200, Johannes Weiner wrote:
> Without swap, anonymous pages are not scanned.  As such, they should
> not count when considering force-scanning a small target if there is
> no swap.
> 
> Otherwise, targets are not force-scanned even when their effective
> scan number is zero and the other conditions--kswapd/memcg--apply.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
