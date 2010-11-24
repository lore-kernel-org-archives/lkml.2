Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0KXDNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:13:37 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29561 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751955Ab0KXDNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:13:36 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6GqKQX8VM1lI1vh2VcWIzXxzpmT_xN2kIFF_wO7toC6L3eH
 Onbt_1zPnpizql7.B7.rD6R47n5.A79ncpXH37JzEEThChGR0hWlS_Fve6Uc
 40K9GXTKAvd_w9TBbx5n3rr2A9B.v1y6ASuadKWkD8tJQQ5CGrzBFDH4Hj7L
 OhultY1nJY5I1XF9on75TETtlQwrtJqD4Csblw6i9YzksP__acqukFlUa1IL
 p4jl1v4TOKA--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 23 Nov 2010 21:13:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <1290558144.2866.122.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011232111350.7446@router.home>
References: <20101123235139.908255844@linux.com>  <20101123235201.758191189@linux.com> <1290558144.2866.122.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Eric Dumazet wrote:

> Hmm, this only works for power of two NR_CPUS, or else one cpu 'tid'
> could wrap on another cpu tid.

Hmm... That essentially like using a bitfield then.

> I suggest using 4096  (or roundup_pow_of_two(CONFIG_NR_CPUS))

There could be machines with 64k cpus soon. So I guess roundupp2 it will
have to be.


