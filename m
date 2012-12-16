Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2LPWZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:25:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:24328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2LPWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:25:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="265084546"
Message-ID: <50CE4A5A.10508@linux.intel.com>
Date: Sun, 16 Dec 2012 14:25:30 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matt Fleming <matt.fleming@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com> <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com> <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com> <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com> <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com> <20121215163323.GA229@x4> <20121215163535.GB229@x4> <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com> <20121216132521.GA251@x4> <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com> <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com> <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
In-Reply-To: <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 02:07 PM, Linus Torvalds wrote:
> On Sun, Dec 16, 2012 at 12:12 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So I'll test it and see, and hope for the best,
> 
> No such luck. Applying your patch and the reverting the revert of the
> EFI date thing results in the same oops in find_vma() from udev that I
> had before.
> 
> So the patch is still scrogged, and it is *not* ready to even be put
> in some "next merge window" pile.
> 

No, we need to get to the bottom with the problem.

	-hpa


