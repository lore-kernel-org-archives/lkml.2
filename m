Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1IWIJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:09:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1IWIJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <1316704637.31429.25.camel@twins>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	<1316030695-19826-2-git-send-email-glommer@parallels.com>
	<1316448186.1511.19.camel@twins>
	<4E776937.1070108@parallels.com>
	<1316449160.6091.5.camel@twins>
	<4E776E36.6040906@parallels.com>
	<1316450385.6091.9.camel@twins>
	<4E7770BD.6050902@parallels.com>
	<1316457653.6091.16.camel@twins>
	<20110920172930.GA5318@linux.vnet.ibm.com>
	<CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com>
	<1316704637.31429.25.camel@twins>
Date: Fri, 23 Sep 2011 13:39:26 +0530
Message-ID: <CAKTCnzk_NoBxQypJBsX9O56=F6z_7HdPY1HW=G=2AkM9tpkbaw@mail.gmail.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Balbir Singh <bsingharora@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Android makes heavy use of cpuacct as well. We invented it to do cpu
>> accounting independent of control
>
> But its a massive waste of time to have to iterate a double hierarchy,
> cache-miss heaven.
>

By double hierarchy you mean both cpu and cpuacct? What if they are
not mounted together?

> Or so people really have independent cgroups as well? I thought people
> just co-mount all this crap.
>

Please see
http://code.google.com/p/cgroupmgr/wiki/cgroupsForAndroid
http://stackoverflow.com/questions/6814207/android-cpuacct-usage-file

AFAIK, some versions mount cpuacct at /acct and independent of cpu cgroups

Balbir
