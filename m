Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1KIL70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:59:26 -0500
Received: from mx2.parallels.com ([64.131.90.16]:35338 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab1KIL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:59:25 -0500
Message-ID: <4EBA6AF7.4020509@parallels.com>
Date: Wed, 9 Nov 2011 09:58:47 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrew Wagin <avagin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>, <pjt@google.com>,
        <fweisbec@gmail.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics inside
 cpu cgroup
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-14-git-send-email-glommer@parallels.com> <CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
In-Reply-To: <CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 09:51 AM, Andrew Wagin wrote:
> Hi Glauber,
>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index d93cfd4..b9296cd 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -303,6 +303,7 @@ struct task_group {
>>
>>         struct cfs_bandwidth cfs_bandwidth;
>>         struct kernel_cpustat __percpu *cpustat;
>> +       u64 __percpu *cpuusage;
>
> I can't find where you use this variable, probably it may be removed.

Indeed.
This is a leftover from the previous attempt.
