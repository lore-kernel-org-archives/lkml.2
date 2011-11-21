Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1KUSwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:52:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:49425 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab1KUSwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:52:40 -0500
Message-ID: <1321901536.28118.20.camel@twins>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Date: Mon, 21 Nov 2011 19:52:16 +0100
In-Reply-To: <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
	 <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
	 <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 13:24 -0500, Vince Weaver wrote:
> On Fri, 18 Nov 2011, tip-bot for Peter Zijlstra wrote:
> 
> > Commit-ID:  ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
> > Gitweb:     http://git.kernel.org/tip/ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 14 Nov 2011 10:03:25 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 14 Nov 2011 13:03:44 +0100
> > 
> > perf/x86: Enable raw event access to Intel offcore events
> 
> awesome.  You can add a "Whined-about-it-at-great-length: Vince Weaver"
> line to the commit logs if you want.  Now I'll have to find something else 
> to complain about, probably the scedulability issue introduced with the
> NMI watchdog.

:-)

But you can disable that thing, right?

echo 0 > /proc/sys/kernel/nmi_watchdog;

or so should do the trick.


