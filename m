Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0LALdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:33:33 -0500
Received: from fep15.mx.upcmail.net ([62.179.121.35]:50232 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0LALdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:33:32 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1291183068.7466.140.camel@marge.simson.net>
References: <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130151749.GE26758@redhat.com>
	 <1291137221.28239.70.camel@marge.simson.net>
	 <20101130193622.GF26758@redhat.com>
	 <1291183068.7466.140.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:33:22 +0100
Message-ID: <1291203202.4023.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvXQbuMnWGQeb488dJ7w43Du7THgE+O7ieb9U20/rjk= c=1 sm=0 a=gKIfv9-gHswA:10 a=IkcTkHD0fZMA:10 a=7qMPYs2lnLYI8HPw-Z0A:9 a=BQZezhZjZM4HEwVQqF3t9prredEA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 06:57 +0100, Mike Galbraith wrote:
> IMHO, cgroups should have been 'nice' from the start, but the folks who
> wrote it did what they thought best.  I like nice a lot better than
> shares, so I used nice. 

Agreed, but by the time I realized that the shares thing was already in
the wild. I did (probably still do) have a patch that adds a nice file
to the cgroup file.

Anyway, I think the whole proc/nice interface for autogroups is already
a tad too far. If people want control they can use cgroups, but I really
don't care enough to argue much about it.



