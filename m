Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0LALga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:36:30 -0500
Received: from fep19.mx.upcmail.net ([62.179.121.39]:40972 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0LALg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:36:29 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101201050129.GA5210@cr0.nay.redhat.com>
References: <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130151749.GE26758@redhat.com>
	 <1291137221.28239.70.camel@marge.simson.net>
	 <20101130193622.GF26758@redhat.com>
	 <20101201050129.GA5210@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:36:22 +0100
Message-ID: <1291203382.4023.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=tMVj8KYobzzX0EiRnC7vY2isLrCxFvdg4RrHWPZXwJ0= c=1 sm=0 a=gKIfv9-gHswA:10 a=IkcTkHD0fZMA:10 a=oltX-cS-elkNFLK3PyEA:9 a=oNRsIWIIUBTQ-v2HD8Q3MtNFbsYA:4 a=QEXdDO2ut3YA:10 a=DX-OgpOofmOqxaeW:21 a=myZf2QWFswRyW73m:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 13:01 +0800, Américo Wang wrote:
> 
> Hmm, maybe we can make AUTO_GROUP depend on !CGROUPS?
> 
> It seems that autogroup only uses 'struct task_group', no other cgroup things,
> so I think that is reasonable and doable. 

That's only going to create more #ifdefery in sched.c (and we already
got way too much of that), for little to no gain.

But yes, technically that could be done.

