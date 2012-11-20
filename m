Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2KTSpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:45:08 -0500
Received: from mail.vyatta.com ([76.74.103.46]:45716 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab2KTSpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:45:06 -0500
Date: Tue, 20 Nov 2012 10:44:00 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: paolo.valente@unimore.it, jhs@mojatatu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
Message-ID: <20121120104400.4832dea1@nehalam.linuxnetplumber.net>
In-Reply-To: <20121120.131516.311189144173456123.davem@davemloft.net>
References: <20121120095304.420ded7c@nehalam.linuxnetplumber.net>
	<20121120.130202.1918742054229219388.davem@davemloft.net>
	<20121120100958.010e7605@nehalam.linuxnetplumber.net>
	<20121120.131516.311189144173456123.davem@davemloft.net>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 13:15:16 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Tue, 20 Nov 2012 10:09:58 -0800
> 
> > On Tue, 20 Nov 2012 13:02:02 -0500 (EST)
> > David Miller <davem@davemloft.net> wrote:
> > 
> >> From: Stephen Hemminger <shemminger@vyatta.com>
> >> Date: Tue, 20 Nov 2012 09:53:04 -0800
> >> 
> >> > There are actually lots of bogus warnings than seem to only occur
> >> > because gcc 4.4 does a bad job of checking. Later versions are fixed
> >> > and don't generate warnings.
> >> > 
> >> > My preference is to not add the unnecessary initialization because
> >> > if you get in the habit of doing it. The whole purpose of the uninitialized
> >> > check is lost. 
> >> 
> >> Try again, this was with gcc-4.7.2-2 on Fedora.
> >> 
> >> There are too many preconditions, across multiple basic block, which
> >> together ensure the skb is in fact initialized at the point in
> >> question and the compiler simply isn't sophisticated enough to see
> >> that.
> > 
> > Weird, it compiles  clean on x86-84 on Debian.
> > gcc-4.7.real (Debian 4.7.2-4) 4.7.2
> 
> Fedora backports a lot more stuff into gcc than Debian does.

Probably. that's it. Plus Fedora has more gcc maintainers.

