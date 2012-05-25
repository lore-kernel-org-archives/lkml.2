Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab2EYU7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:59:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43805 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2EYU7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120420020013.GA19964@windriver.com>
References: <20120420020013.GA19964@windriver.com>
Date: Fri, 25 May 2012 22:59:10 +0200
X-Google-Sender-Auth: -H-8xuDeljyBl6MjVs3MfEXKtWM
Message-ID: <CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
Subject: Re: linux-next: triage for April 19, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>, Avi Kivity <avi@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> The parisc got borked by some kvm header shuffle it seems?
> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]

Not only parisc.

This breakage has now entered mainline:

parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
