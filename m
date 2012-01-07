Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2AGHzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 02:55:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2AGHzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 02:55:23 -0500
Date: Fri, 6 Jan 2012 23:59:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: David Rientjes <rientjes@google.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [resubmit] Re: [patch-final] Re: patch] cpusets, cgroups:
 disallow attaching kthreadd
Message-Id: <20120106235941.006f7981.akpm@linux-foundation.org>
In-Reply-To: <1325918057.6514.17.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
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
	<1323227914.5057.10.camel@marge.simson.net>
	<1323232617.5057.50.camel@marge.simson.net>
	<20120106140625.f5447039.akpm@linux-foundation.org>
	<1325918057.6514.17.camel@marge.simson.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jan 2012 07:34:17 +0100 Mike Galbraith <efault@gmx.de> wrote:

> I can't get to mmotm to see what's there, but fresh pulled linux-next
> has it as 904655b9, and looked ok. (?)  The only thing I can think to do
> is post it as just plugged into fresh pulled master and hope that helps
> turn little floundering guppy right side up again.

master is not where the problems lies.  It's recent vandalism in
linux-next which is breaking things.  Let's leave it a few days, see if
things get sorted out.


