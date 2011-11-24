Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1KXQ6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:58:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:44817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1KXQ6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:58:30 -0500
Message-ID: <1322153899.2921.71.camel@twins>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com, fweisbec@gmail.com
Date: Thu, 24 Nov 2011 17:58:19 +0100
In-Reply-To: <4ECE731E.6030508@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	   <1320182360-20043-15-git-send-email-glommer@parallels.com>
	   <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
	   <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	   <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	   <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	   <4EC47632.2000904@parallels.com>
	   <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	   <4EC52F32.2040708@parallels.com>
	   <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
	  <1322141073.2921.51.camel@twins> <4ECE6BC4.7090600@parallels.com>
	 <1322152152.2921.64.camel@twins> <4ECE731E.6030508@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 14:38 -0200, Glauber Costa wrote:
> It's hard for me to say that, since I come from a virtualization 
> background: for us, a single cgroup would do just fine: even the 
> division between mem and cpu is not needed. However, I've been learning 
> recently that the use cases for that are quite diverse. So I'll have to 
> leave the answer to Balbir, and other interested parties. 

Hehe, I'm the one running a CGROUP=n kernel, so what do I know. Its just
that all this stuff hurts my brain.

Maybe we should just add functionality that requires controllers to be
co-mounted and this extra functionality will then make people co-mount
since you know features.. :-)

I know I've wanted to do that several times, so far I've always resisted
because it looked like pain, but hey, if I can cause more pain somewhere
else and my life gets easier in the long run I might change my mind ;-)
