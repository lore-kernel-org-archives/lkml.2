Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1J3VvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 17:51:19 -0400
Received: from smtprelay0118.b.hostedemail.com ([64.98.42.118]:51871 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab1J3VvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 17:51:18 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2448
Date: Sun, 30 Oct 2011 21:51:17 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: hmh@hmh.eng.br
Cc: linux-kernel@vger.kernel.org
Message-ID: <815860869.50724.1320011477430.JavaMail.mail@webmail17>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030212644.GA7106@khazad-dum.debian.net>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.147.51.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Oct 31, 2011, Henrique de Moraes Holschuh wrote: 
>
> On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
> > I've found out that even on Linux 3.0.8 the process scheduler doesn't correctly distributes
> > the load amongst virtual CPUs. E.g. on a 4-core system (8 total virtual CPUs) the process
> > scheduler often run some instances of four different tasks on the same physical CPU.
> 
> Please check how your sched_mc_power_savings and sched_smt_power_savings
> tunables.   Here's the doc from lesswats.org:
> 
> [cut]
> 
> Please make sure both are set to 0.  If they were not 0 at the time you
> ran your tests, please retest and report back.
> 
> You also want to make sure you _do_ have the SMT scheduler compiled in
> whatever kernel you're using, just in case.
> 
> It is certainly possible that there is a bug in the scheduler, but it is
> best to make sure it is not something else, first.
> 
> You may also want to refer to: http://oss.intel.com/pdfs/mclinux.pdf and
> to the irqbalance and hwloc[1] utilities, since you're apparently
> interested in SMP/SMT/NUMA scheduler performance.

That's 0 & 0 for me.

And people running standard desktop Linux distributions (like Arch Linux and Ubuntu
11.10) report that this issue also applies to them and by default (in the mentioned
distros) both these variables are set to 0 (that is unchanged).

So, there's nothing to retest.

I have another major pet peeve concerning the Linux process scheduler but I
want to start a new thread on that topic.

Best wishes,

Artem


