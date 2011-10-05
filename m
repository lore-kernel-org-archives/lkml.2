Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab1JEMRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:17:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59869 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab1JEMRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:17:41 -0400
Message-ID: <4E8C4AC1.5050202@parallels.com>
Date: Wed, 5 Oct 2011 16:17:05 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>  <1317583287-18300-10-git-send-email-glommer@parallels.com> <1317806048.6766.8.camel@twins>
In-Reply-To: <1317806048.6766.8.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 01:14 PM, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>> +       if (tg->cpustat)
>> +               free_percpu(tg->cpustat);
>> +       if (tg->cpuusage)
>> +               free_percpu(tg->cpuusage);
>
> void free_percpu(void __percpu *ptr)
> {
>          void *addr;
>          struct pcpu_chunk *chunk;
>          unsigned long flags;
>          int off;
>
>          if (!ptr)
>                  return;
> 	...
> }
Silly me.

