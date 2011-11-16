Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1KPXx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:53:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab1KPXx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:53:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Nov 2011 08:52:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
Message-Id: <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	<CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 15:51:27 +0530
Balbir Singh <bsingharora@gmail.com> wrote:

> >
> > On the other hand, I don't think much discussion remains for cpuacct,
> > everyone's pretty unanimous in that they'd like to see it deprecated.
> > By splitting this up we can close out that quickly while we figure out the
> > best way to resolve the above.
> >
> 
> I'd give it a thumbs up, if we can create sched groups and provide
> accounting without control - like we can for the memory cgroup today.
> 

Isn't it possible ?

Thanks,
-Kame

