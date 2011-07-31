Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1GaXNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:13:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:52977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GaXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:13:11 -0400
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Mon, 01 Aug 2011 00:13:07 +0100
In-Reply-To: <20110731225801.GD2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
	 <1312066923.22074.53.camel@i7.infradead.org>
	 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	 <1312151063.18010.25.camel@i7.infradead.org>
	 <20110731224834.GC2203@ZenIV.linux.org.uk>
	 <20110731225801.GD2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312153988.18010.39.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 23:58 +0100, Al Viro wrote:
> FWIW, the next step (still not pushed there) is to move arch/um/sys-x86 to
> arch/x86/um, with arch/um/os-Linux/sys-x86 becoming arch/x86/um/os-Linux,
> Kconfig.x86 moving to arch/x86/um/Kconfig and Makefile-x86 - to
> arch/x86/um/Makefile.defs.  Next after that - arch/powerpc/um (and yes,
> it means resurrected uml/ppc port; for now - only ppc32, since I have no
> ppc64 boxen to test on). 

I can give you an account on a ppc64 box if that would help...

What you've done so far, with the one extra patch I just sent, seems
perfectly sufficient to make it cope with SUBARCH defaulting to x86
instead of to i386 or x86_64. Are you happy to push it before you do the
rest of the refactoring/moving?

-- 
dwmw2

