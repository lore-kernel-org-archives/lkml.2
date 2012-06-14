Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2FNRr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab2FNRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:47:58 -0400
Message-ID: <4FDA237B.8020703@redhat.com>
Date: Thu, 14 Jun 2012 13:46:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: kosaki.motohiro@gmail.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages
 to the buddy allocator again
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 12:16 PM, kosaki.motohiro@gmail.com wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

