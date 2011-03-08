Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1CHP2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:28:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1CHP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:28:00 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=KGpMX1y64oQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SsqvmWhbArpA4C4ZRkYA:9 a=WmKHAScU5DBIixzBbHQvojNQpMUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been released for
 FEBRUARY 2011.
From: Steven Rostedt <rostedt@goodmis.org>
To: CAI Qian <caiqian@redhat.com>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sf.net, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1121368325.334177.1299551594318.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <1121368325.334177.1299551594318.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 10:27:58 -0500
Message-ID: <1299598078.20306.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 21:33 -0500, CAI Qian wrote:
> > Perhaps we need to get developer's tests into the kernel. We now have a
> > tools/testing directory lets use it.
> There are a few test code span over other directories too.
> Documentation/vm/hugepage-mmap.c
> Documentation/vm/hugepage-shm.c
> Documentation/vm/map_hugetlb.c

These all look like "Examples", which means they should probably be
moved to samples? As "samples" can be compiled on boot. But perhaps
because they are user space programs its fine to keep them here?

-- Steve

> ...



