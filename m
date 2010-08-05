Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab0HEPUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab0HEPUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:20:23 -0400
Message-ID: <4C5AD686.9040503@redhat.com>
Date: Thu, 05 Aug 2010 11:19:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/7] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com> <20100805151125.31BA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100805151125.31BA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 02:12 AM, KOSAKI Motohiro wrote:
> From: Wu Fengguang<fengguang.wu@intel.com>
>
> Fix "system goes unresponsive under memory pressure and lots of
> dirty/writeback pages" bug.
>
> 	http://lkml.org/lkml/2010/4/4/86
>
> In the above thread, Andreas Mohr described that
>
> 	Invoking any command locked up for minutes (note that I'm
> 	talking about attempted additional I/O to the _other_,
> 	_unaffected_ main system HDD - such as loading some shell
> 	binaries -, NOT the external SSD18M!!).
>
> This happens when the two conditions are both meet:
> - under memory pressure
> - writing heavily to a slow device

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
