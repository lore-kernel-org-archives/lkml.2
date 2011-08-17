Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HQBTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:19:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36805 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1HQBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:19:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Aug 2011 10:12:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Ying Han <yinghan@google.com>, Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 1/2] mm: vmscan: fix force-scanning small targets
 without swap
Message-Id: <20110817101208.c8bbed4a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 22:31:54 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Without swap, anonymous pages are not scanned.  As such, they should
> not count when considering force-scanning a small target if there is
> no swap.
> 
> Otherwise, targets are not force-scanned even when their effective
> scan number is zero and the other conditions--kswapd/memcg--apply.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Ying Han <yinghan@google.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Mel Gorman <mel@csn.ul.ie>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

