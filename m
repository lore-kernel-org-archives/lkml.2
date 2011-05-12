Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1ELPiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab1ELPiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:38:19 -0400
Message-ID: <4DCBF67A.3060700@redhat.com>
Date: Thu, 12 May 2011 11:02:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 1/6] memcg: remove unused retry signal from reclaim
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org> <1305212038-15445-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1305212038-15445-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 10:53 AM, Johannes Weiner wrote:
> If the memcg reclaim code detects the target memcg below its limit it
> exits and returns a guaranteed non-zero value so that the charge is
> retried.
>
> Nowadays, the charge side checks the memcg limit itself and does not
> rely on this non-zero return value trick.
>
> This patch removes it.  The reclaim code will now always return the
> true number of pages it reclaimed on its own.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: Rik van Riel<riel@redhat.com>

