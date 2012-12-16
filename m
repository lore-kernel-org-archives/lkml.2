Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2LPWIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:08:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62978 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2LPWIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <20121215163535.GB229@x4> <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121216132521.GA251@x4> <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
 <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 14:07:42 -0800
X-Google-Sender-Auth: i66vj0BL6mSpiMjg8VJl_F2ummk
Message-ID: <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
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

On Sun, Dec 16, 2012 at 12:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'll test it and see, and hope for the best,

No such luck. Applying your patch and the reverting the revert of the
EFI date thing results in the same oops in find_vma() from udev that I
had before.

So the patch is still scrogged, and it is *not* ready to even be put
in some "next merge window" pile.

               Linus
