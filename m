Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1KPKV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:21:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1KPKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:21:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
Date: Wed, 16 Nov 2011 15:51:27 +0530
Message-ID: <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Balbir Singh <bsingharora@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On the other hand, I don't think much discussion remains for cpuacct,
> everyone's pretty unanimous in that they'd like to see it deprecated.
> By splitting this up we can close out that quickly while we figure out the
> best way to resolve the above.
>

I'd give it a thumbs up, if we can create sched groups and provide
accounting without control - like we can for the memory cgroup today.

Balbir
