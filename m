Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2FPG57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:57:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51308 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2FPG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:57:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDC2DEA.6010300@jp.fujitsu.com>
Date: Sat, 16 Jun 2012 15:55:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: kosaki.motohiro@gmail.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages
 to the buddy allocator again
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/15 1:16), kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> 
> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
> another miuse still exist.
> 
> This patch fixes it.
> 
> Cc: David Rientjes<rientjes@google.com>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Minchan Kim<minchan.kim@gmail.com>
> Cc: Wu Fengguang<fengguang.wu@intel.com>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


