Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1KYFor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 00:44:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59653 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1KYFoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 00:44:46 -0500
MIME-Version: 1.0
In-Reply-To: <4ECE731E.6030508@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	<CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	<20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	<4EC47632.2000904@parallels.com>
	<CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	<4EC52F32.2040708@parallels.com>
	<20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
	<1322141073.2921.51.camel@twins>
	<4ECE6BC4.7090600@parallels.com>
	<1322152152.2921.64.camel@twins>
	<4ECE731E.6030508@parallels.com>
Date: Fri, 25 Nov 2011 11:08:23 +0530
Message-ID: <CAKTCnznU1jA9ME2F12pPSLosi3=sbiHPikPd3UDon3arBK6XLQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Balbir Singh <bsingharora@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:08 PM, Glauber Costa <glommer@parallels.com> wrote:
> It's hard for me to say that, since I come from a virtualization background:
> for us, a single cgroup would do just fine: even the division between mem
> and cpu is not needed. However, I've been learning recently that the use
> cases for that are quite diverse. So I'll have to leave the answer to
> Balbir, and other interested parties.
>

It is not about $customer. I am OK with a design that allows
accounting independent of control. Put it another way when I look at
cgroups, I see the following functionality

1. Accounting and feedback
2. Control

Why do 1 and 2 have to co-exist. A good case would be that we might
need just stats and might want to implement control based on 1. But if
I have to do both 1 and 2 together, how do we decide on control
values?

Balbir
