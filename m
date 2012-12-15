Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2LOVHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:07:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54916 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LOVHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:07:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121215210411.GA228@x4>
References: <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CCD24F.9090603@zytor.com> <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
 <20121215210411.GA228@x4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Dec 2012 13:06:55 -0800
X-Google-Sender-Auth: pUiml27ZyuFCSSw_IDd8x6o3iuI
Message-ID: <CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@suse.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 1:04 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> So I wonder if the following simple patch might be enough?
> It fixes the issue for me at least.

Not enough.

It presumably fixes the issue for you by hiding the problem. But if
you were to boot a kernel with EFI support, it would re-surface.
Including in any distro kernel that obviously will include EFI support
in order to handle the generic case.

I've reverted the commit.

              Linus
