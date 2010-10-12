Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0JLAVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:21:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab0JLAVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:21:20 -0400
Date: Mon, 11 Oct 2010 17:22:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>, yinghai@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-Id: <20101011172226.6162476c.akpm@linux-foundation.org>
In-Reply-To: <20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100929122206.GA30317@sgi.com>
	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
	<20101004143414.GA4261@sgi.com>
	<20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
	<20101008163557.GA13859@sgi.com>
	<20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 09:09:07 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > > 
> > > How about this ? This is an add-on patch.
> > 
> > Nice!!
> > 
> > The combination of the 2 patches solves the problem.
> > The timings are (4096p, 256 nodes, 4592 irqs):
> > 
> > 	# time cat /proc/stat > /dev/null
> > 
> > 	Baseline:		12.627 sec
> > 	Patch1  :		 2.459 sec
> > 	Patch 1 + Patch 2:	  .561 sec
> > 
> > 
> > Acked-by: Jack Steiner <steiner@sgi.com>
> > 
> 
> Thank you for testing. I'll post again if necessary.

Yes please.  This has been going on for two weeks so memories need
refreshing.  Also we have no patch title and no changelog which
includes the testing results.

I could stitch all that together of course, but it's best that it all
be done afresh, I think.

