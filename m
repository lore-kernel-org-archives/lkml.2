Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1GFRgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:36:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:56764 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1GFRgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="23370323"
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
	<1309624184-9790-4-git-send-email-fweisbec@gmail.com>
	<4E1185F3020000780004BF21@nat28.tlf.novell.com>
	<20110704125742.GB1915@somewhere.redhat.com>
Date: Wed, 06 Jul 2011 10:34:42 -0700
In-Reply-To: <20110704125742.GB1915@somewhere.redhat.com> (Frederic
	Weisbecker's message of "Mon, 4 Jul 2011 14:57:45 +0200")
Message-ID: <m2sjqj71ot.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:
>
> I really did not think about code duplication, considering
> it's better to optimize the irq entry path.
>
> What do you guys think? We can still revert the whole patchset.

FWIW I think it should be a macro, like it was in the original code.

Optimizing entry*.S for code size doesn't make a lot of sense.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
