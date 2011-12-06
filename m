Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab1LFKcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:32:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab1LFKcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:32:43 -0500
Date: Tue, 6 Dec 2011 11:31:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -tip] x86: fix build without CONFIG_X86_MRST
Message-ID: <20111206103103.GC15966@elte.hu>
References: <1323166702-12990-1-git-send-email-sgruszka@redhat.com>
 <20111206103022.434ebf6f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206103022.434ebf6f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue,  6 Dec 2011 11:18:22 +0100
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > Fix compilation error when compiled with CONFIG_X86_INTEL_MID and
> > without CONFIG_X86_MRST:
> > 
> > arch/x86/built-in.o: In function `add_rtc_cmos':
> > rtc.c:(.init.text+0x34bd): undefined reference to `__mrst_cpu_chip'
> 
> It really is INTEL_MID wide, but there were other problems 
> with the way the INTEL_MID selection was done. Should be fixed 
> with the patch I sent Ingo.

Hm, i didnt realize that it broke the build upstream as well. I 
improved your changelog to indicate the build failure and also 
cherry-picked it over from tip:x86/platform (v3.3 material) into 
tip:x86/urgent (v3.2 fixes).

Thanks,

	Ingo
