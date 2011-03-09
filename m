Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1CIBeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 20:34:36 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42867 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1CIBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:34:35 -0500
Date: Tue, 8 Mar 2011 20:33:48 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sf.net, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Theodore Tso <tytso@MIT.EDU>
Message-ID: <1470848644.363281.1299634428564.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1299598078.20306.70.camel@gandalf.stny.rr.com>
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been released for
 FEBRUARY 2011.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Perhaps we need to get developer's tests into the kernel. We now
> > > have a
> > > tools/testing directory lets use it.
> > There are a few test code span over other directories too.
> > Documentation/vm/hugepage-mmap.c
> > Documentation/vm/hugepage-shm.c
> > Documentation/vm/map_hugetlb.c
> 
> These all look like "Examples", which means they should probably be
> moved to samples? As "samples" can be compiled on boot. But perhaps
> because they are user space programs its fine to keep them here?
Yes, but also test cases to check if basic hugetlb code is working.
Well, the problem is that they are all over the place, and some of
good test cases are within commit logs as well which makes things
harder to maintain, use...

CAI Qian
