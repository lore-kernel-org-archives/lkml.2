Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0LAGJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:09:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37503 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750735Ab0LAGJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:09:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+U1g1iBwaUNkeWV6iWZzkeFTj53yTv9/h+LuZR6V
	a+8K6/JFK2ppeM
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Date: Wed, 01 Dec 2010 07:09:09 +0100
Message-Id: <1291183749.7466.143.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 13:01 +0800, Américo Wang wrote:

> Hmm, maybe we can make AUTO_GROUP depend on !CGROUPS?
> 
> It seems that autogroup only uses 'struct task_group', no other cgroup things,
> so I think that is reasonable and doable.

Build time exclusion is not as flexible.  As is, the user can have one
kernel, and use whatever he likes.

	-Mike

