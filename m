Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab1JEPGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:06:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42413 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934472Ab1JEPGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:06:19 -0400
Message-ID: <4E8C7246.3060700@parallels.com>
Date: Wed, 5 Oct 2011 19:05:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Balbir Singh <bsingharora@gmail.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>   <1317583287-18300-10-git-send-email-glommer@parallels.com>  <1317807988.6766.10.camel@twins> <4E8C4C23.8000007@parallels.com> <1317817881.6766.11.camel@twins>
In-Reply-To: <1317817881.6766.11.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 04:31 PM, Peter Zijlstra wrote:
> On Wed, 2011-10-05 at 16:22 +0400, Glauber Costa wrote:
>>
>> We should at least sum up se and rt_se, right?
>
> Ah yes indeed.

sched_rt.c:

         curr->se.sum_exec_runtime += delta_exec;

Where did I get this crazy idea about rt_se from? I swear I did not do 
any drugs today...

>> Otherwise... I will re-read the code, but from a first sight, I think
>> you are right.
>
> Good, less hierarchy walks ->  *win*

