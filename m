Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LAPEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:04:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752443Ab0LAPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:04:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/oKA1bEzjoyJNkb1kxZRycTryel9a/Rmd4vM/tam
	xiL6rwiLgBF4Y+
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101201145556.GE4672@redhat.com>
References: <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130151749.GE26758@redhat.com>
	 <1291137221.28239.70.camel@marge.simson.net>
	 <20101130193622.GF26758@redhat.com>
	 <1291183068.7466.140.camel@marge.simson.net>
	 <20101201145556.GE4672@redhat.com>
Content-Type: text/plain
Date: Wed, 01 Dec 2010 16:04:01 +0100
Message-Id: <1291215841.3882.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 09:55 -0500, Vivek Goyal wrote:

> So IIUC, if a task is in root cgroup, then it would not necessarily be driven
> by cpu.shares of root cgroup (as task could be in its own autogroup). But
> if I move the task into a non-root cgroup, then it will for sure be
> subjected to rules imposed by non-root cgroup cpu.shares. That's not too
> bad.

I think the normal case would be either one or the other being in use at
any given time, but yes, if both are active, that's how it'd work.

	-Mike

