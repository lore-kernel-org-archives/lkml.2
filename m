Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2FPHU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 03:20:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39549 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2FPHUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 03:20:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDC3359.6090204@jp.fujitsu.com>
Date: Sat, 16 Jun 2012 16:18:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: fix page reclaim comment error
References: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/14 21:41), Wanpeng Li wrote:
> From: Wanpeng Li<liwp@linux.vnet.ibm.com>
> 
> Since there are five lists in LRU cache, the array nr in get_scan_count
> should be:
> 
> nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
> nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
> 
> Signed-off-by: Wanpeng Li<liwp.linux@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

