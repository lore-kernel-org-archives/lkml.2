Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab2FNRww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2FNRwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:52:51 -0400
Message-ID: <4FDA24BA.7070306@redhat.com>
Date: Thu, 14 Jun 2012 13:51:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: fix page reclaim comment error
References: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1339677662-25942-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 08:41 AM, Wanpeng Li wrote:
> From: Wanpeng Li<liwp@linux.vnet.ibm.com>
>
> Since there are five lists in LRU cache, the array nr in get_scan_count
> should be:
>
> nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
> nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
>
> Signed-off-by: Wanpeng Li<liwp.linux@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
