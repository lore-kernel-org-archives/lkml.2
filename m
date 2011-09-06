Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1IFOys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab1IFOyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:54:43 -0400
Date: Tue, 6 Sep 2011 16:51:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906145124.GA15390@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906031411.GA24024@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Andi Kleen wrote:
>
> > I forgot everything I knew about ->it_requeue_pending logic, but it
> > seems to me that do_schedule_next_timer()->lock_timer() can find and
> > lock successfully the wrong timer. Another thread can do timer_delete()
> > and then re-create the timer with the same id.
>
> Do you mean after my patches or even before?

Ah, sorry for confusion.

Before. And after. IOW, I think this has nothing to do with your patches.

Oleg.

