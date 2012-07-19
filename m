Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2GSKBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:01:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2GSKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:01:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5007DA01.5060903@jp.fujitsu.com>
Date: Thu, 19 Jul 2012 18:57:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] mm: memcg: push down PageSwapCache check into uncharge
 entry functions
References: <1342026142-7284-1-git-send-email-hannes@cmpxchg.org> <1342026142-7284-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1342026142-7284-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/12 2:02), Johannes Weiner wrote:
> Not all uncharge paths need to check if the page is swapcache, some of
> them can know for sure.
> 
> Push down the check into all callsites of uncharge_common() so that
> the patch that removes some of them is more obvious.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

