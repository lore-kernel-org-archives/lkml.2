Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1FIBOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1FIBOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:14:05 -0400
Message-ID: <4DF01E26.5060003@redhat.com>
Date: Wed, 08 Jun 2011 21:13:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org> <BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com> <BANLkTi=kJ-r=bZqB8X+KAu+ueapXYLjxnLNRdxRAkDGWk4k_AA@mail.gmail.com>
In-Reply-To: <BANLkTi=kJ-r=bZqB8X+KAu+ueapXYLjxnLNRdxRAkDGWk4k_AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 08:35 PM, Greg Thelen wrote:
> On Wed, Jun 1, 2011 at 4:52 PM, Hiroyuki Kamezawa
> <kamezawa.hiroyuki@gmail.com>  wrote:

>> 1. No more conflict with Ying's work ?
>>     Could you explain what she has and what you don't in this v2 ?
>>     If Ying's one has something good to be merged to your set, please
>> include it.
>>
>> 2. it's required to see performance score in commit log.
>>
>> 3. I think dirty_ratio as 1st big patch to be merged. (But...hmm..Greg ?
>>     My patches for asynchronous reclaim is not very important. I can rework it.
>
> I am testing the next version (v8) of the memcg dirty ratio patches.  I expect
> to have it posted for review later this week.

Sounds like you guys might need a common git tree to
cooperate on memcg work, and not step on each other's
toes quite as often :)

A git tree has the added benefit of not continuously
trying to throw out each other's work, but building
on top of it.

-- 
All rights reversed
