Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1GLBSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:18:33 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:38083 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1GLBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:18:32 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, Faidon Liambotis <paravoid@debian.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Willy Tarreau <w@1wt.eu>, Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	<BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	<20110705231515.95bc758f.akpm@linux-foundation.org>
From: =?iso-2022-jp?B?TUlOT1VSQSBNYWtvdG8gLyAbJEJMJzE6GyhCIBskQj8/GyhC?= 
	<minoura@valinux.co.jp>
Date: Tue, 12 Jul 2011 10:18:30 +0900
In-Reply-To: <20110705231515.95bc758f.akpm@linux-foundation.org> (Andrew Morton's message of "Tue\, 5 Jul 2011 23\:15\:15 -0700")
Message-ID: <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're experiencing similar but slightly different
problems.  Some KVM hosts crash after 210-220 uptime.
Some of them hits divide-by-zero, but one of them shows:

[671528.8780080] BUG: soft lockup - CPU#4 stuck for 61s! [kvm:11131]

(sorry we have no full crash message including the backtrace)

The host kernel is 2.6.32.11-based (ubuntu 2.6.32-22-server,
2.6.32-22.36).

I'm not sure but probably the task scheduler is confusing by
the sched_clock overflow?

Thanks,

-- 
Minoura Makoto <minoura@valinux.co.jp>
