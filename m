Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2ENRfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:35:30 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34771 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604Ab2ENRf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:35:29 -0400
Date: Mon, 14 May 2012 10:35:26 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: codel: fix build errors
Message-ID: <20120514103526.1f1a4399@nehalam.linuxnetplumber.net>
In-Reply-To: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com>
References: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 19:14:47 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> Fix the following build error:
> 
> net/sched/sch_fq_codel.c: In function 'fq_codel_dump_stats':
> net/sched/sch_fq_codel.c:464:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:464:3: warning: missing braces around initializer
> net/sched/sch_fq_codel.c:464:3: warning: (near initialization for 'st.<anonymous>')
> net/sched/sch_fq_codel.c:465:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:465:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:465:3: warning: (near initialization for 'st')
> net/sched/sch_fq_codel.c:466:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:466:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:466:3: warning: (near initialization for 'st')
> net/sched/sch_fq_codel.c:467:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:467:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:467:3: warning: (near initialization for 'st')
> make[1]: *** [net/sched/sch_fq_codel.o] Error 1
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Which Gcc version, looks like your compiler is old.
