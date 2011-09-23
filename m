Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1IWOgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:36:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:34288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1IWOgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:36:08 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Date: Fri, 23 Sep 2011 16:35:26 +0200
In-Reply-To: <CAKTCnzk_NoBxQypJBsX9O56=F6z_7HdPY1HW=G=2AkM9tpkbaw@mail.gmail.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-2-git-send-email-glommer@parallels.com>
	 <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
	 <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>
	 <1316450385.6091.9.camel@twins> <4E7770BD.6050902@parallels.com>
	 <1316457653.6091.16.camel@twins> <20110920172930.GA5318@linux.vnet.ibm.com>
	 <CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com>
	 <1316704637.31429.25.camel@twins>
	 <CAKTCnzk_NoBxQypJBsX9O56=F6z_7HdPY1HW=G=2AkM9tpkbaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316788526.9084.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 13:39 +0530, Balbir Singh wrote:
> >> Android makes heavy use of cpuacct as well. We invented it to do cpu
> >> accounting independent of control
> >
> > But its a massive waste of time to have to iterate a double hierarchy,
> > cache-miss heaven.
> >
> 
> By double hierarchy you mean both cpu and cpuacct? 

Yes

> What if they are not mounted together?

I was asking if there was a real reason not to have that.

> > Or so people really have independent cgroups as well? I thought people
> > just co-mount all this crap.
> >
> 
> Please see
> http://code.google.com/p/cgroupmgr/wiki/cgroupsForAndroid
> http://stackoverflow.com/questions/6814207/android-cpuacct-usage-file
> 
> AFAIK, some versions mount cpuacct at /acct and independent of cpu cgroups

They do now, but can that be fixed? Is there a sane use-case?

Overhead really must come down of all this crap.
