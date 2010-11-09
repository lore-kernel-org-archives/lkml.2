Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0KINeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:34:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0KINea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:34:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6 v3] ARM: Add support for the display controllers in VT8500 and WM8505
Date: Tue, 9 Nov 2010 14:33:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Alexey Charkov <alchark@gmail.com>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101109110407.GE2869@n2100.arm.linux.org.uk> <AANLkTinWNoGJoDu6Ok8Ni5OuAXN29H7Bd3YMyUq6qfFq@mail.gmail.com>
In-Reply-To: <AANLkTinWNoGJoDu6Ok8Ni5OuAXN29H7Bd3YMyUq6qfFq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091433.45387.arnd@arndb.de>
X-Provags-ID: V02:K0:sJLNTo4WE8beLFzflnuLpCozKE+NuzJi4k/mVmjCEWO
 XTnoJC/hRQZELYsfdsFft9+FlE4DifyC7UO5WgDaSgT+WBFXKv
 82UbCZKrq5N5wzgRUrKD/wrP2YJHJsNMi1t/sapfPeDZ+ysSBh
 UB1WznV4rsc9RgTM4PVzkSlBPvdAn3GStHBMCeD1MpVQwfh0Ej
 A1qEmhhLVmhPiNIS4dnaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 November 2010, Geert Uytterhoeven wrote:
> >
> > It looks to me like the only arch in the kernel which doesn't support
> > generic irq is sh.
> 
> IIRC, m68k, sparc32, and s390.

Yes, and among those, no driver in s390 should need asm/irq.h either because
they do not have interrupt numbers -- every device on s390 has an implicit
interrupt.

	Arnd
