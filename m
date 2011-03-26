Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1CZJby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 05:31:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1CZJbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 05:31:52 -0400
Date: Sat, 26 Mar 2011 10:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110326093131.GA8706@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980>
 <20110324083959.GE30812@elte.hu>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <alpine.LFD.2.02.1103260036300.28928@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103260036300.28928@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> Personally, my oldest usable laptop is a T23 from March 2002.
> It supports APM and ACPI (it shipped with Win2K).
> Linux works well on it in ACPI mode, but doesn't even boot in APM mode.
> If anybody was really using the latest kernel in APM mode,
> I suspect this laptop would boot...

I boot non-ACPI kernels all the time:

  mercury:~> grep -E 'PM|ACPI' /proc/config.gz 
  mercury:~> 
  mercury:~> uname -a
  Linux mercury 2.6.38-tip+ #110579 SMP Sat Mar 26 11:47:58 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

How does it fail for you?

Could you describe the steps you'd like to see from folks using APM to see it 
tested? What kernel configs, BIOS options, etc., what should they see in the 
syslog, etc. - to make sure APM mode is still working fine?

Thanks,

	Ingo
