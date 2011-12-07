Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1LGAFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:05:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1LGAF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:05:28 -0500
Date: Tue, 6 Dec 2011 16:05:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch-final] Re: patch] cpusets, cgroups: disallow attaching
 kthreadd
Message-Id: <20111206160527.d8e3115a.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	<4E7C2E7F.40307@cn.fujitsu.com>
	<1316762345.8168.4.camel@marge.simson.net>
	<alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	<1316770936.6641.11.camel@marge.simson.net>
	<1316775204.7562.9.camel@marge.simson.net>
	<alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	<1316788392.6544.33.camel@marge.simson.net>
	<1318224892.6161.45.camel@marge.simson.net>
	<1318233815.6527.5.camel@marge.simson.net>
	<1318925436.9641.23.camel@marge.simson.net>
	<CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
	<1319001860.6222.34.camel@marge.simson.net>
	<alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com>
	<20111206144721.7b1d473d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 15:53:47 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> Would 
> you like the change separated into kernel/cpuset.c and kernel/sched.c 
> portions each referring to each other?

Nope.

> Mike, would you mind resending the patch for the fourth or fifth time?  If 
> not, I'll rebase it.

Oh goody.
