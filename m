Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2HPJiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:38:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:40366 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2HPJiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:38:54 -0400
Message-ID: <1345109897.11751.31.camel@pasglop>
Subject: Re: [PATCH 1/4] cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 16 Aug 2012 19:38:17 +1000
In-Reply-To: <20120816095336.4eeb3ce1@de.ibm.com>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	 <1344953810-20564-2-git-send-email-fweisbec@gmail.com>
	 <20120815170347.323507b1@de.ibm.com> <20120815190901.GD19716@somewhere>
	 <20120816095336.4eeb3ce1@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 09:53 +0200, Martin Schwidefsky wrote:
> Hmm, ok. But then the description should be reworded not to be specific to
> the power architecture (the part of the message about "This also enables
> accounting of stolen time on logically-partitioned systems running on IBM
> POWER5-based machines."). 

Which is not very helpful to somebody running on a POWER6 or 7 (which
also support that option just fine :-)

So yes, the description should definitely be improved.

Cheers,
Ben.


