Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1L2Qnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:43:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37462 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1L2Qnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:43:37 -0500
Message-ID: <1325177015.9304.9.camel@hp>
Subject: Re: SCHED_RR && time_slice
From: Kirill Tkhai <kirill.tkhai@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Dec 2011 20:43:35 +0400
In-Reply-To: <20111226165930.GA4075@redhat.com>
References: <1324584060.4222.15.camel@hp> <20111226165930.GA4075@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the answers, Oleg.

On Mon, 2011-12-26 at 17:59 +0100, Oleg Nesterov wrote:
> On 12/23, Kirill Tkhai wrote:
> >
> > RT class uses its own fixed
> > timeslice (in case of RR),
> 
> which looks confusing too, btw.
> 
> sched_set_scheduler() does not initialize rt.time_slice, and
> INIT_TASK() sets time_slice = HZ (not DEF_TIMESLICE).
> 

I talk about task_tick_rt(). When time_slice is over, it is being
renewed. New value is DEF_TIMESLICE. This happens in case of SCHED_RR
class.

Kirill

