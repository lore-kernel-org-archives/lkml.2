Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2HOPHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:07:34 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:35214 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2HOPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:07:33 -0400
Date: Wed, 15 Aug 2012 17:07:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] sched: Move cputime code to its own file
Message-ID: <20120815170721.08875f29@de.ibm.com>
In-Reply-To: <1344953810-20564-3-git-send-email-fweisbec@gmail.com>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-3-git-send-email-fweisbec@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081515-4966-0000-0000-0000033A1DFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 16:16:48 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Extract cputime code from the giant sched/core.c and
> put it in its own file. This make it easier to deal with
> this particular area and de-bloat a bit more core.c

To move the cputime accouting code to its own file makes sense.
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

