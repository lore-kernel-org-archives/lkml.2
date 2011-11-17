Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1KQCuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:50:39 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53303 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab1KQCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:50:37 -0500
Message-ID: <4EC47632.2000904@parallels.com>
Date: Thu, 17 Nov 2011 00:49:22 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <fweisbec@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-15-git-send-email-glommer@parallels.com> <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com> <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com> <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com> <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [189.2.73.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 09:52 PM, KAMEZAWA Hiroyuki wrote:
> On Wed, 16 Nov 2011 15:51:27 +0530
> Balbir Singh<bsingharora@gmail.com>  wrote:
>
>>>
>>> On the other hand, I don't think much discussion remains for cpuacct,
>>> everyone's pretty unanimous in that they'd like to see it deprecated.
>>> By splitting this up we can close out that quickly while we figure out the
>>> best way to resolve the above.
>>>
>>
>> I'd give it a thumbs up, if we can create sched groups and provide
>> accounting without control - like we can for the memory cgroup today.
>>
>
> Isn't it possible ?
>
> Thanks,
> -Kame
>
I must say I don't really understand what exactly you propose, and how 
it is different from what we have today.

My take is that you are talking about a single cgroup in which you can 
have the functionality of both cpuacct and cpu, but surrounded by knobs 
that allows you to turn them off individually.

Am I right?
