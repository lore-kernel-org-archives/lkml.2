Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0GBLjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:39:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:60680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab0GBLjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:39:04 -0400
Subject: Re: [PATCH] perf wrong branches event on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 13:38:47 +0200
Message-ID: <1278070727.1917.253.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 15:30 -0400, Vince Weaver wrote:
> This is why event selection needs to be in user-space... it could be fixed 
> instantly there, but the way things are done now it will take months to 
> years for this fix to filter down to those trying to use perf counters...

Last time I checked apt-get upgrade/yum upgrade simply upgraded
everything, including kernels.. (and upgrades to userspace packages can
take months too)

Someone needs to build a new package and publish it, upgrading the
kernel is no harder than upgrading any other.

If you don't want to reboot, there's the -r option Arnaldo already
mentioned. There's also the option of writing a kernel module to poke at
the data table if you really really want to update a running kernel.

If you think this is a really "important" feature you could even make a
patch that exposes all these data tables to userspace through sysfs or
whatever and see if people think its worth the effort.

Personally I don't think people will ever use such a sysfs interface,
but hey, that's my opinion.
