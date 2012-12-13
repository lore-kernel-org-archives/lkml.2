Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2LMH1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:27:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LMH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:27:40 -0500
Date: Thu, 13 Dec 2012 08:27:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
Message-ID: <20121213072733.GA13124@gmail.com>
References: <20121211090910.GA22985@gmail.com>
 <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com>
 <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com>
 <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com>
 <CA+55aFz0aW8sA_51x8RxLd=bR=0izMJtRJm68bKqueJU9OKQsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz0aW8sA_51x8RxLd=bR=0izMJtRJm68bKqueJU9OKQsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 12, 2012 at 8:31 PM, David Ahern <dsahern@gmail.com> wrote:
> >
> >
> > See commit 26a4f3c0. But that was not enough.
> 
> Why? Make the people who run virtualization do the extra work. Things
> never worked for them anyway, so forcing *them* to set a flag to get a
> working thing is sane.
> 
> Forcing everybody else to set a flag is insane. See?

Yeah, that's 100% stupid, we'll revert this change.

Arnado, wanna do it or should I? This slipped through the 
testing cracks ...

Thanks,

	Ingo
