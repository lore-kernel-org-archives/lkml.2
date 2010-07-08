Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0GHNXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab0GHNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:23:46 -0400
Message-ID: <4C35D139.90006@redhat.com>
Date: Thu, 08 Jul 2010 09:23:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages,
 not page order
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com> <20100708163934.CD37.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100708163934.CD37.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 03:40 AM, KOSAKI Motohiro wrote:
> Fix simple argument error. Usually 'order' is very small value than
> lru_pages. then it can makes unnecessary icache dropping.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
