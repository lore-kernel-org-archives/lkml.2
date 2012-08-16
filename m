Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2HPHxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:53:47 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:46176 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2HPHxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:53:46 -0400
Date: Thu, 16 Aug 2012 09:53:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
Message-ID: <20120816095336.4eeb3ce1@de.ibm.com>
In-Reply-To: <20120815190901.GD19716@somewhere>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-2-git-send-email-fweisbec@gmail.com>
	<20120815170347.323507b1@de.ibm.com>
	<20120815190901.GD19716@somewhere>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081607-2966-0000-0000-00000502AAD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012 21:09:04 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Aug 15, 2012 at 05:03:47PM +0200, Martin Schwidefsky wrote:
> > On Tue, 14 Aug 2012 16:16:47 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > S390, ia64 and powerpc all define their own version
> > > of CONFIG_VIRT_CPU_ACCOUNTING. Generalize the config
> > > and its description to a single place to avoid
> > > duplication.
> > 
> > For S390 CONFIG_VIRT_CPU_ACCOUNTING is not configurable, it is always
> > enabled. With this patch we'd get a config option in the menu, no?
> 
> Indeed it now appears in the menu but in the case of s390, it's impossible
> to turn it off due to:
> 
> 	config S390
> 		select VIRT_CPU_ACCOUNTING
> 
> This creates a strict dependency that the user can't override. The option
> is untoggable.

Hmm, ok. But then the description should be reworded not to be specific to
the power architecture (the part of the message about "This also enables
accounting of stolen time on logically-partitioned systems running on IBM
POWER5-based machines.").

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

