Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2DXXwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:52:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48846 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2DXXww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:52:52 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F973C66.2090307@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 08:51:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Documentation: memcg: future proof hierarchical statistics
 documentation
References: <1335296038-29297-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1335296038-29297-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 4:33), Johannes Weiner wrote:

> The hierarchical versions of per-memcg counters in memory.stat are all
> calculated the same way and are all named total_<counter>.
> 
> Documenting the pattern is easier for maintenance than listing each
> counter twice.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Ying Han <yinghan@google.com>


I'm fine with this.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

