Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab2AEXwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:52:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2AEXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:52:34 -0500
Date: Thu, 5 Jan 2012 15:52:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitri Sivanich <sivanich@sgi.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120105155233.0d367bc3.akpm@linux-foundation.org>
In-Reply-To: <20120105182949.e35b2430b915b50e4bb9bc04@canb.auug.org.au>
References: <20120105182949.e35b2430b915b50e4bb9bc04@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 18:29:49 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/time/tick-sched.c:874:7: warning: 'struct sysdev_attribute' declared inside parameter list [enabled by default]
>
> ...
>
> Caused by commit 629d589817da ("tick-sched: add specific do_timer_cpu
> value for nohz off mode") interacting with the removal of sysdevs in the
> driver-core tree.  This patch will need reworking for that.
> 
> I have reverted that commit for today.

Bah.  I dropped it.

I must say, this week was a maximally inappropriate time to merge all this
sysdev stuff into linux-next.

