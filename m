Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LTRxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:53:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:50069 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTRxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:53:49 -0500
Date: Thu, 20 Dec 2012 18:53:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kirill Tkhai <tkhai@yandex.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to
 "struct rq"
In-Reply-To: <4807701355857948@web19f.yandex.ru>
Message-ID: <alpine.LFD.2.02.1212201852060.3148@ionos>
References: <4807701355857948@web19f.yandex.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Kirill Tkhai wrote:

> The members rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks are
> properties of cpu runqueue, not group rt_rq.

Why?

Thanks,

	tglx

