Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1LZRFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:05:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab1LZRFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:05:15 -0500
Date: Mon, 26 Dec 2011 17:59:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <kirill.tkhai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Kirill Tkhai <tkhai@yandex.ru>
Subject: SCHED_RR && time_slice
Message-ID: <20111226165930.GA4075@redhat.com>
References: <1324584060.4222.15.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324584060.4222.15.camel@hp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Kirill Tkhai wrote:
>
> RT class uses its own fixed
> timeslice (in case of RR),

which looks confusing too, btw.

sched_set_scheduler() does not initialize rt.time_slice, and
INIT_TASK() sets time_slice = HZ (not DEF_TIMESLICE).

Oleg.

