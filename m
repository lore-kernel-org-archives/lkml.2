Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1HCOay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:30:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1HCOau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:30:50 -0400
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." =?ISO-8859-1?Q?Gon=E7alves?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1312317372.18583.101.camel@gandalf.stny.rr.com>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 16:29:51 +0200
Message-ID: <1312381791.1147.323.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 16:36 -0400, Steven Rostedt wrote:
> commit 84d342f89dd0bf7d9a01c9802021f01a5ff1c453
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Mon Aug 1 13:20:05 2011 -0400
> 
>     sched/cpupri: Remove the vec->lock 

Thanks!
