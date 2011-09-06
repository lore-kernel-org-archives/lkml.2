Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1IFDOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:14:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:5957 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1IFDOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,336,1312182000"; 
   d="scan'208";a="48361080"
Date: Mon, 5 Sep 2011 20:14:11 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906031411.GA24024@alboin.amr.corp.intel.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
 <1314661157-22173-4-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.02.1109021135270.2723@ionos>
 <20110904165658.GA23948@redhat.com>
 <20110904202907.GA3404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904202907.GA3404@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I forgot everything I knew about ->it_requeue_pending logic, but it
> seems to me that do_schedule_next_timer()->lock_timer() can find and
> lock successfully the wrong timer. Another thread can do timer_delete()
> and then re-create the timer with the same id.

Do you mean after my patches or even before?
-Andi
