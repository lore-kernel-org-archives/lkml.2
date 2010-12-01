Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0LALzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:55:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51839 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751526Ab0LALzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:55:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Gn/w9CQzGG98B28OAwOWowB8f5pfJWRC2GFDXPQ
	Mr6b2UTnlGq8hx
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1291203202.4023.5.camel@twins>
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
	 <1291203202.4023.5.camel@twins>
Content-Type: text/plain
Date: Wed, 01 Dec 2010 12:55:44 +0100
Message-Id: <1291204544.3882.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 12:33 +0100, Peter Zijlstra wrote:

> Anyway, I think the whole proc/nice interface for autogroups is already
> a tad too far. If people want control they can use cgroups, but I really
> don't care enough to argue much about it.

Agreed.  I've no intention of expanding it.

	-Mike

