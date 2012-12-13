Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2LMDes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:34:48 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48635 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2LMDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <50C94A9C.2050900@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 19:34:26 -0800
X-Google-Sender-Auth: JA8YQwFd3MdN8Q20Tlf7MZ6LQkM
Message-ID: <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 7:25 PM, David Ahern <dsahern@gmail.com> wrote:
>
> Are you running an older perf binary on the 3.8 kernel?

I am.. I don't tend to rebuild 'perf'..

> Does this work: perf record -e cycles:ppH  ...

Yes it does. What is 'H' and why should anybody care? Especially since
I'm not running virtualized.

That whole "exclude_guest" test is insane when there isn't any
virtualization going on. Very annoying.

                Linus
