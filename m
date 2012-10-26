Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2JZJ4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:56:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:33386 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2JZJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:56:54 -0400
Date: Fri, 26 Oct 2012 11:56:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, "he, bo" <bo.he@intel.com>
Subject: Re: [PATCH V2] hrtimer:__run_hrtimer races with enqueue_hrtimer
In-Reply-To: <1351241719.2207.17.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.LFD.2.02.1210261156060.2756@ionos>
References: <1351241719.2207.17.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Yanmin Zhang wrote:
> Basically, __run_hrtimer has a race with enqueue_hrtimer. When __run_hrtimer calls

NAK. See my reply to V1. It's not a race in the core code.

Thanks,

	tglx
