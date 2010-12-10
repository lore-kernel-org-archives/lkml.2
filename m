Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0LJQSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:18:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59482 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0LJQSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:18:03 -0500
Subject: Re: [tip:sched/urgent] Sched: fix skip_clock_update optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, bbb.lst@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=z3kQJfRqpA5iw91CWyGKnuAC1+qWdao_mS5+4@mail.gmail.com>
References: <1291802742.1417.9.camel@marge.simson.net>
	 <tip-f26f9aff6aaf67e9a430d16c266f91b13a5bff64@git.kernel.org>
	 <1291908773.29292.16.camel@twins>
	 <AANLkTi=z3kQJfRqpA5iw91CWyGKnuAC1+qWdao_mS5+4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 17:17:48 +0100
Message-ID: <1291997868.13513.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 10:33 +0800, Yong Zhang wrote:
> 
> I don't see it on my side.
> Then just show some info(don't know if it's helpful):
> wake_up_idle_cpu() can set TIF_RESCHED locklessly.
> 
> So does
> WARN_ON_ONCE(next != rq->idle && test_tsk_need_resched(next));
> help?

Its a good possibility, sadly I haven't been able to reproduce so I
cannot confirm. I'll keep my machine running, maybe it will trigger in a
few hours.
