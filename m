Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1GFXjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:39:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:39097 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1GFXjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,489,1304319600"; 
   d="scan'208";a="23537435"
From: Andi Kleen <andi@firstfloor.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
	<1308681903-12840-1-git-send-email-vnagarnaik@google.com>
	<CAL26m8KYPCoJzRVsVXCmEAqXKiaRGZu840potVD+83JR27tfCg@mail.gmail.com>
Date: Wed, 06 Jul 2011 16:38:21 -0700
In-Reply-To: <CAL26m8KYPCoJzRVsVXCmEAqXKiaRGZu840potVD+83JR27tfCg@mail.gmail.com>
	(Vaibhav Nagarnaik's message of "Wed, 6 Jul 2011 14:50:11 -0700")
Message-ID: <m2k4bv6kuq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaibhav Nagarnaik <vnagarnaik@google.com> writes:
>
> Can you please take a look at this patch? Does it cover all the generic
> IRQ handlers so they are traced?

It seems quite complete from a quick look. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
