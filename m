Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2FWEZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:25:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36755 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2FWEZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:25:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE544A2.1050500@jp.fujitsu.com>
Date: Sat, 23 Jun 2012 13:22:58 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] memcg: cleanup typos in mem cgroup
References: <1340369199-29535-1-git-send-email-liwp.linux@gmail.com> <20120622150358.GB16628@tiehlicka.suse.cz> <20120623021547.GA2227@kernel>
In-Reply-To: <20120623021547.GA2227@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/23 11:16), Wanpeng Li wrote:
> On Fri, Jun 22, 2012 at 05:03:59PM +0200, Michal Hocko wrote:
>> Have you used any tool to find those typos? Have you gone through the
>> whole memcontrol.c file?
>> I am not agains fixes like this but I would much prefer if it was one
>> batch of all fixes. I bet there are more typose ;)
>
> OK, I will figure out them and resend the patch.
>

It's helpful. Thank you.

-Kame

