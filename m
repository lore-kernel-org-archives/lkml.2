Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab1GLBk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:40:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52807 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1GLBk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:40:26 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: MINOURA Makoto / =?UTF-8?Q?=E7=AE=95=E6=B5=A6_=E7=9C=9F?= 
	<minoura@valinux.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Willy Tarreau <w@1wt.eu>, Rand@jasper.es
In-Reply-To: <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	 <20110428183434.GG30645@1wt.eu>	<20110429100200.GB23293@pcnci.linuxbox.cz>
	 <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 18:40:19 -0700
Message-ID: <1310434819.30337.21.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 10:18 +0900, MINOURA Makoto / 箕浦 真 wrote:
> We're experiencing similar but slightly different
> problems.  Some KVM hosts crash after 210-220 uptime.
> Some of them hits divide-by-zero, but one of them shows:
> 
> [671528.8780080] BUG: soft lockup - CPU#4 stuck for 61s! [kvm:11131]
> 
> (sorry we have no full crash message including the backtrace)
> 
> The host kernel is 2.6.32.11-based (ubuntu 2.6.32-22-server,
> 2.6.32-22.36).
> 
> I'm not sure but probably the task scheduler is confusing by
> the sched_clock overflow?

I'm working on a debug patch that will hopefully trip sched_clock
overflows very early to see if we can't shake these issues out.

thanks
-john


