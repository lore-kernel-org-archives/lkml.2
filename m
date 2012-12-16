Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2LPWkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:40:15 -0500
Received: from mga07.intel.com ([143.182.124.22]:22253 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983Ab2LPWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:40:13 -0500
Message-ID: <1355697606.2903.39.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
From: Matt Fleming <matt.fleming@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Date: Sun, 16 Dec 2012 22:40:06 +0000
In-Reply-To: <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
	 <23916.1355356085@warthog.procyon.org.uk>
	 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
	 <21507.1355528749@warthog.procyon.org.uk>
	 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
	 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
	 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
	 <20121215163323.GA229@x4> <20121215163535.GB229@x4>
	 <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121216132521.GA251@x4>
	 <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
	 <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-16 at 14:07 -0800, Linus Torvalds wrote:
> On Sun, Dec 16, 2012 at 12:12 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So I'll test it and see, and hope for the best,
> 
> No such luck. Applying your patch and the reverting the revert of the
> EFI date thing results in the same oops in find_vma() from udev that I
> had before.
> 
> So the patch is still scrogged, and it is *not* ready to even be put
> in some "next merge window" pile.

Linus have you got a stacktrace for the oops (and maybe even a dmesg)? I
suspect it won't tell us much, but any/all info we can gather will help.

At this point, I'm wondering if insert_identity_mapping() is trashing
valid mappings.

