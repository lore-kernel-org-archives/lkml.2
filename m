Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2ENKgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:36:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54973 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2ENKgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:36:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB0DFBE.2000106@jp.fujitsu.com>
Date: Mon, 14 May 2012 19:34:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/memcg: get_lru_size not get_lruvec_size
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils> <alpine.LSU.2.00.1205132158470.6148@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205132158470.6148@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/14 14:00), Hugh Dickins wrote:

> Konstantin just introduced mem_cgroup_get_lruvec_size() and
> get_lruvec_size(), I'm about to add mem_cgroup_update_lru_size():
> but we're dealing with the same thing, lru_size[lru].  We ought to
> agree on the naming, and I do think lru_size is the more correct:
> so rename his ones to get_lru_size().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

