Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0JNGwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:52:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab0JNGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:52:51 -0400
Date: Thu, 14 Oct 2010 08:52:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip  0/5] Kprobes updates
Message-ID: <20101014065237.GD23561@elte.hu>
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> This series of patches fixes some code/docs which are related to
> kprobes (especially optprobe).
> First 2 resend patches update document and selftest since
> optprobe changes kprobes behavior.
> Next 2 patches fix double get_cpu() by using __stop_machine().
> And the last patch makes text_poke_smp() depending on
> stop_machine() on smp, because without stop_machine(),
> it can't ensure safety on smp.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (5):
>       [BUGFIX] kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency
>       [BUGFIX] x86: Use __stop_machine() in text_poke_smp()
>       Define __stop_machine when CONFIG_STOP_MACHINE=n
>       [RESEND][BUGFIX] kprobes: Fix selftest to clear flags field for reusing probes
>       [RESEND] kprobes: Update document about irq disabled state in kprobe handler
> 
> 
>  Documentation/kprobes.txt     |    8 +++++---
>  arch/x86/Kconfig              |    5 +++++
>  arch/x86/kernel/alternative.c |    3 ++-
>  include/linux/stop_machine.h  |   10 ++++++++--
>  kernel/test_kprobes.c         |   12 +++++++++---
>  5 files changed, 29 insertions(+), 9 deletions(-)

Applied to tip:perf/core, thanks a lot Masami!

	Ingo
