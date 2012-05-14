Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2ENWAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:00:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45764 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab2ENWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:00:44 -0400
Subject: Re: [PATCH v2] net: codel: fix build errors
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com>
References: <1337032626-7104-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 00:00:38 +0200
Message-ID: <1337032838.8512.642.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 23:57 +0200, Sasha Levin wrote:
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
> ---

Acked-by: Eric Dumazet <edumazet@google.com>


