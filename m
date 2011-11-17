Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1KQC6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:58:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57800 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KQC6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <4EC47632.2000904@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	<CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	<20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	<4EC47632.2000904@parallels.com>
Date: Thu, 17 Nov 2011 08:28:08 +0530
Message-ID: <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Balbir Singh <bsingharora@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 8:19 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 11/16/2011 09:52 PM, KAMEZAWA Hiroyuki wrote:
>>
>> On Wed, 16 Nov 2011 15:51:27 +0530
>> Balbir Singh<bsingharora@gmail.com>  wrote:
>>
>>>>
>>>> On the other hand, I don't think much discussion remains for cpuacct,
>>>> everyone's pretty unanimous in that they'd like to see it deprecated.
>>>> By splitting this up we can close out that quickly while we figure out
>>>> the
>>>> best way to resolve the above.
>>>>
>>>
>>> I'd give it a thumbs up, if we can create sched groups and provide
>>> accounting without control - like we can for the memory cgroup today.
>>>
>>
>> Isn't it possible ?
>>
>> Thanks,
>> -Kame
>>
> I must say I don't really understand what exactly you propose, and how it is
> different from what we have today.
>
> My take is that you are talking about a single cgroup in which you can have
> the functionality of both cpuacct and cpu, but surrounded by knobs that
> allows you to turn them off individually.
>
> Am I right?
>

No here is what I am asking for

I don't want CPU control, just accounting, so I create the following groups

                          a
                       /    \
                      V    V
                      b     c

Today, with the cpu controller, the moment I create a, b and c, they
get default shares and if I put tasks, their b/w is decided by the
shares, what if I don't want control, but I want to account for their
time only?

Balbir
