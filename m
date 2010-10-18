Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab0JRCBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 22:01:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48735 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0JRCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 22:01:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process
Cc: kosaki.motohiro@jp.fujitsu.com, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101018013622.GA21722@nowhere>
References: <20101018102609.3ADF.A69D9226@jp.fujitsu.com> <20101018013622.GA21722@nowhere>
Message-Id: <20101018104259.3AE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Oct 2010 11:01:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Oct 18, 2010 at 10:28:43AM +0900, KOSAKI Motohiro wrote:
> > > On Wed, 2010-10-06 at 05:32 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.
> > > > 
> > > > Have seen this three times now while trying to attach gdb to a hung Firefox
> > > > process.
> > > > 
> > > > [20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> > > > [20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d
> > > 
> > > Known issue I think, Frederic was looking into curing this.
> > > 
> > > Frederic, what's the current status of that?
> > 
> > mmotm1014 seems still have this issue. Frederic, can you please tell us
> > current status if you are tracking this issue?
> 
> 
> Peter has a pending queue for .37 which includes:
> 
> 	[RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in hw_breakpoint creation
> 
> This patch should fix the issue (it depends on others in the queue).
> 
> What is mmotm1014 BTW? Because you should see this bug only in a tree
> that has tip:/perf/core merged inside, like linux-next.

mmotm is (usually) linux-next + akpm fixes. if a change of tip is exported
to linux-next, it is visible from mmotm tester :)



