Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0IBPlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0IBPlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:41:11 -0400
Message-ID: <4C7FC585.9090401@redhat.com>
Date: Thu, 02 Sep 2010 11:40:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] vmscan: prevent background aging of anon page in no
 swap system
References: <1283441862-15855-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1283441862-15855-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 11:37 AM, Minchan Kim wrote:

> This patch prevents unnecessary anon pages demotion in not-yet-swapon and
> non-configured swap system. Even, in non-configuared swap system
> inactive_anon_is_low can be compiled out.

> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Signed-off-by: Ying Han<yinghan@google.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
