Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0FYOQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0FYOQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:16:21 -0400
Message-ID: <4C24BA05.9070201@redhat.com>
Date: Fri, 25 Jun 2010 10:15:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: recalculate lru_pages on each priority
References: <20100625181221.805A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100625181221.805A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 05:13 AM, KOSAKI Motohiro wrote:
> shrink_zones() need relatively long time. and lru_pages can be
> changed dramatically while shrink_zones().
> then, lru_pages need recalculate on each priority.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
