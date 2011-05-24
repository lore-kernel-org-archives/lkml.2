Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1EXNoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:44:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab1EXNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:43:58 -0400
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 15:47:16 +0200
Message-ID: <1306244836.2497.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
> If there are pushable tasks and they are high enough in priority, in which
> case task p is covered, the current could keep holding its CPU.

-ENOPARSE.. 

> Even if current task has to release its CPU, requeuing task p could result in
> starvation of tasks that are of same priority and have been waiting on RQ for
> a couple of hours:/ 

Starvation of the same priority tasks is a perfectly valid situation for
SCHED_FIFO, also, your changelog fails to mention what you propose to do
about it.

