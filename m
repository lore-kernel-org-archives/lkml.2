Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab0GIOcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:32:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab0GIOcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:32:51 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278682707.6083.227.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 16:32:31 +0200
Message-ID: <1278685951.1900.215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
>  - do you think it could be useful to have a different syscall to deal
>    with the period parameter (if it's different from deadline), e.g.,
>    something useful to make the task periodic as you have (if I remember
>    well) in Xenomai or RTAI?
>    If you think it's worth doing that, do you think the
>    task_wait_interval() syscall that we already added could/should do
>    the job? 

Again, I'm afraid I need some extra education here in order to make a
sensible comment.

What are the exact semantics of this extra proposed syscall?

What exactly are the benefits over not having it, and simply rely on the
task to not wake up more often, but if it does have it run into the lack
of budget and sort it that way?
