Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2LPXtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 18:49:06 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:33337 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2LPXtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 18:49:05 -0500
Date: Mon, 17 Dec 2012 00:49:00 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
Message-ID: <20121216234900.GA232@x4>
References: <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <20121215163535.GB229@x4>
 <1355661820.2903.25.camel@mfleming-mobl1.ger.corp.intel.com>
 <20121216132521.GA251@x4>
 <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
 <CA+55aFy_xU6FryKX+pJ697B3+jRjRTniEVxn4quCs-tB-Qz7rw@mail.gmail.com>
 <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxJcyTdtO5SWQK0YZyO_tEqPmL17oa8t3pX2meu30HR+Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.12.16 at 14:07 -0800, Linus Torvalds wrote:
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

Hm, I just double checked my logs and it looks like I've booted the
wrong kernel. The new patch fails for me, too. 
Sorry for the confusion.

-- 
Markus
