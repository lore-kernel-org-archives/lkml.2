Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2LPUMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:12:49 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38424 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2LPUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:12:48 -0500
MIME-Version: 1.0
In-Reply-To: <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <20121215163535.GB229@x4> <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121216132521.GA251@x4> <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 12:12:21 -0800
X-Google-Sender-Auth: 32gYRNm9QBFUeJdwohxzeOfSToA
Message-ID: <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Matt Fleming <matt.fleming@intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 6:54 AM, Matt Fleming <matt.fleming@intel.com> wrote:
>
> At least we now know the problem wasn't caused by a memory map issue,
> just my buggy patch.
>
> Linus, Peter, how should we proceed from here? Since the commit and its
> dependants have been reverted should we punt for now and try again next
> merge window?

Hmm. Since we're several days away from the merge window closing, I
think I can apply your fixed patch and then undo the revert. But I'll
need to feel confident that it works for me too, because I absolutely
detest having kernels that I can't use for development myself (which
is why I _very_ aggressively revert stuff that I notice myself: if
it's a problem reported by some random user, I try to give developers
time to fix it if they are responding to the problem report, but if
it's a problem that means that I can't use the current -git tree
myself, I tend to revert much more aggressively).

So I'll test it and see, and hope for the best,

           Linus
