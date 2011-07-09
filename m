Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1GIO1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:27:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47695 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1GIO1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110708084629.73c7e543.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110707155217.909c429a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110707142922.c9657ec4.akpm@linux-foundation.org>
	<20110708084629.73c7e543.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 9 Jul 2011 19:57:30 +0530
Message-ID: <CAKTCnz=tKo=769oPq+vQxykYYy36GDZL4XpuHuFGKT-LitSytQ@mail.gmail.com>
Subject: Re: [PATCH][Cleanup] memcg: consolidates memory cgroup lru stat functions
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The memcg code sometimes uses "struct mem_cgroup *mem" and sometimes
>> uses "struct mem_cgroup *memcg".  That's irritating.  I think "memcg"
>> is better.
>>
>
> Sure. I always use "mem" but otheres not ;(
> Ok, I'll use memcg.

This would be a good cleanup to do. CC'ing Raghavendra who might be
interested in looking at the cleanup

Balbir
