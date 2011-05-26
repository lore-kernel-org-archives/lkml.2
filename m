Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1EZJ4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:56:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47883 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab1EZJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:56:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDE23C8.5000000@jp.fujitsu.com>
Date: Thu, 26 May 2011 18:56:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <1912242417.242053.1306402480853.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1912242417.242053.1306402480853.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -160,7 +162,7 @@ unsigned int oom_badness(struct task_struct *p,
>> struct mem_cgroup *mem,
>> */
>> if (p->flags & PF_OOM_ORIGIN) {
>> task_unlock(p);
>> - return 1000;
>> + return ULONG_MAX;
>> }
> This part failed to apply to the latest git tree so unable to test those
> patches this time. Can you fix that?

Please apply ontop mmotm-0512.

Thanks.


