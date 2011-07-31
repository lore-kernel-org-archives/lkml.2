Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1GaXRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:17:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58706 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GaXRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:17:18 -0400
MIME-Version: 1.0
In-Reply-To: <1312153988.18010.39.camel@i7.infradead.org>
References: <1312066693.22074.50.camel@i7.infradead.org>
	<1312066923.22074.53.camel@i7.infradead.org>
	<CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	<1312151063.18010.25.camel@i7.infradead.org>
	<20110731224834.GC2203@ZenIV.linux.org.uk>
	<20110731225801.GD2203@ZenIV.linux.org.uk>
	<1312153988.18010.39.camel@i7.infradead.org>
Date: Mon, 1 Aug 2011 01:17:17 +0200
Message-ID: <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not SUBARCH_i386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 1:13 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2011-07-31 at 23:58 +0100, Al Viro wrote:
>> FWIW, the next step (still not pushed there) is to move arch/um/sys-x86 to
>> arch/x86/um, with arch/um/os-Linux/sys-x86 becoming arch/x86/um/os-Linux,
>> Kconfig.x86 moving to arch/x86/um/Kconfig and Makefile-x86 - to
>> arch/x86/um/Makefile.defs.  Next after that - arch/powerpc/um (and yes,
>> it means resurrected uml/ppc port; for now - only ppc32, since I have no
>> ppc64 boxen to test on).
>
> I can give you an account on a ppc64 box if that would help...

Isn't UML on ppc broken since ages?
As I don't have a ppc box I could never test it...

-- 
Thanks,
//richard
