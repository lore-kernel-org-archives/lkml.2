Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2HOPD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:03:57 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:57569 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2HOPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:03:56 -0400
Date: Wed, 15 Aug 2012 17:03:47 +0200
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
Message-ID: <20120815170347.323507b1@de.ibm.com>
In-Reply-To: <1344953810-20564-2-git-send-email-fweisbec@gmail.com>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-2-git-send-email-fweisbec@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081515-6892-0000-0000-000002B813C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 16:16:47 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> S390, ia64 and powerpc all define their own version
> of CONFIG_VIRT_CPU_ACCOUNTING. Generalize the config
> and its description to a single place to avoid
> duplication.

For S390 CONFIG_VIRT_CPU_ACCOUNTING is not configurable, it is always
enabled. With this patch we'd get a config option in the menu, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

