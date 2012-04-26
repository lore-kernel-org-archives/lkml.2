Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DZCDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:03:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51126 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2DZCDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:03:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F98AC9A.2080001@jp.fujitsu.com>
Date: Thu, 26 Apr 2012 11:02:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: move pc lookup point to commit_charge()
References: <1335295860-28919-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1335295860-28919-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 4:31), Johannes Weiner wrote:

> None of the callsites actually need the page_cgroup descriptor
> themselves, so just pass the page and do the look up in there.
> 
> We already had two bugs (6568d4a 'mm: memcg: update the correct soft
> limit tree during migration' and 'memcg: fix Bad page state after
> replace_page_cache') where the passed page and pc were not referring
> to the same page frame.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

