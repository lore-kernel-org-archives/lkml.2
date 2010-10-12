Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0JLBHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 21:07:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab0JLBH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 21:07:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Oct 2010 10:02:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, yinghai@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-Id: <20101012100207.4efbdab6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101011172226.6162476c.akpm@linux-foundation.org>
References: <20100929122206.GA30317@sgi.com>
	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
	<20101004143414.GA4261@sgi.com>
	<20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
	<20101008163557.GA13859@sgi.com>
	<20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>
	<20101011172226.6162476c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 17:22:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 12 Oct 2010 09:09:07 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > > 
> > > > How about this ? This is an add-on patch.
> > > 
> > > Nice!!
> > > 
> > > The combination of the 2 patches solves the problem.
> > > The timings are (4096p, 256 nodes, 4592 irqs):
> > > 
> > > 	# time cat /proc/stat > /dev/null
> > > 
> > > 	Baseline:		12.627 sec
> > > 	Patch1  :		 2.459 sec
> > > 	Patch 1 + Patch 2:	  .561 sec
> > > 
> > > 
> > > Acked-by: Jack Steiner <steiner@sgi.com>
> > > 
> > 
> > Thank you for testing. I'll post again if necessary.
> 
> Yes please.  This has been going on for two weeks so memories need
> refreshing.  Also we have no patch title and no changelog which
> includes the testing results.
> 
> I could stitch all that together of course, but it's best that it all
> be done afresh, I think.
> 
ok, will do today.

-Kame

