Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0EFGS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:18:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0EFGS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:18:28 -0400
Date: Thu, 6 May 2010 08:18:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86 acpi/irq:  Define gsi_end when X86_IO_APIC is
 undefined
Message-ID: <20100506061816.GA1172@elte.hu>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
 <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
 <20100505085629.GA16278@elte.hu>
 <j2taca0ce8b1005050236z8448bb27wacebbb2cf2de0fd4@mail.gmail.com>
 <20100505100500.GA12693@elte.hu>
 <m1tyqm14la.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tyqm14la.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Oops.  My recent changes introducing a global gsi_end variable failed
> to take into account the case of using acpi on a system not built to
> support IO_APICs, causing the build to fail.  Define gsi_end to 15 when
> CONFIG_X86_IO_APIC is not set to avoid compile errors.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/x86/include/asm/io_apic.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied to tip:x86/irq, thanks Eric!

	Ingo
