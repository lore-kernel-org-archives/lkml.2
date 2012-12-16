Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2LPOzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 09:55:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:53565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2LPOy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 09:54:59 -0500
Message-ID: <1355669692.2903.33.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
From: Matt Fleming <matt.fleming@intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 16 Dec 2012 14:54:52 +0000
In-Reply-To: <20121216132521.GA251@x4>
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
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-16 at 14:25 +0100, Markus Trippelsdorf wrote:
> Matt, your patch fixes the problem for me. Thanks.

That's great! Thanks for testing so quickly.

At least we now know the problem wasn't caused by a memory map issue,
just my buggy patch.

Linus, Peter, how should we proceed from here? Since the commit and its
dependants have been reverted should we punt for now and try again next
merge window?

