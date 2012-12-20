Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2LTWRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:17:15 -0500
Received: from forward15.mail.yandex.net ([95.108.130.119]:46699 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTWRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:17:04 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1212201852060.3148@ionos>
References: <4807701355857948@web19f.yandex.ru> <alpine.LFD.2.02.1212201852060.3148@ionos>
Subject: Re: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to "struct rq"
MIME-Version: 1.0
Message-Id: <401821356041818@web4f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 21 Dec 2012 02:16:58 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.12.2012, 21:53, "Thomas Gleixner" <tglx@linutronix.de>:
> On Tue, 18 Dec 2012, Kirill Tkhai wrote:
>
>> šThe members rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks are
>> šproperties of cpu runqueue, not group rt_rq.
>
> Why?

Because, they depend on number and properties of all processes of rq, not of nested rt_rq.

>
> Thanks,
>
> šššššššštglx
