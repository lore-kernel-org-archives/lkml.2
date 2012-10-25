Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035Ab2JYRt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:49:59 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:46580 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934720Ab2JYRt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 25 Oct 2012 19:49:55 +0200
Message-ID: <CAFTL4hyY4hhyT5FzvdEaALavbfrxCiqBTt+50A89J3LeptvpkQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] cputime: Moar cleanups / enhancements v3
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/25 Frederic Weisbecker <fweisbec@gmail.com>:
> Hi,
>
> Changes since v2:
>
> - Fix missing EXPORT_SYMBOL_GPL (thanks Wu Fenguang for the report)
> - Drop that *_irqsafe naming, use vtime_account_system() as irq safe
> and __vtime_account_system() for the raw arch implementation
> - Drop local_irq_disable() on s390 kvm guest switch
>
> If you want to test, it is pullable from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         cputime/cleanups-v3

It's cputime/cleanups-v4, sorry.
