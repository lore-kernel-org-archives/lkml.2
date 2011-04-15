Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1DOOaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:30:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:46127 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1DOOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:30:14 -0400
Date: Fri, 15 Apr 2011 16:30:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org
Subject: Re: [PATCH V5] futex: set FLAGS_HAS_TIMEOUT during futex_wait restart
 setup
In-Reply-To: <4DA85114.3010501@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1104151629340.2744@localhost6.localdomain6>
References: <daac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart@linux.intel.com> <alpine.LFD.2.00.1104151027260.2744@localhost6.localdomain6> <4DA85114.3010501@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Darren Hart wrote:
> I believe I asked you the same question when I was adding the
> FLAGS_HAS_TIMEOUT. :-) The problem is distinguishing between no timeout
> and an expired timer. The above always passes a non-null address for
> abs_time to futex_wait(), which will then always schedule a timer.

Duh, correct.

