Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0FKHWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:22:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab0FKHWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:22:01 -0400
Subject: Re: [PATCH 0/5] sched/cpu-timers: task->signal is stable now
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100610230939.GA25895@redhat.com>
References: <20100610230939.GA25895@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Jun 2010 09:21:46 +0200
Message-ID: <1276240906.2077.1476.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 01:09 +0200, Oleg Nesterov wrote:
> With the recent changes task->signal is pinned to task_struct,
> it is always valid and can't go away. We can simplify some code
> in sched / posix-cpu-timers files.

Nice!
