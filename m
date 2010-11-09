Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0KIQVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:21:19 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48981 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KIQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:21:18 -0500
Date: Wed, 10 Nov 2010 01:20:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Charkov <alchark@gmail.com>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 6/6 v3] ARM: Add support for the display controllers in VT8500 and WM8505
Message-ID: <20101109162055.GA22740@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101109110407.GE2869@n2100.arm.linux.org.uk> <AANLkTinWNoGJoDu6Ok8Ni5OuAXN29H7Bd3YMyUq6qfFq@mail.gmail.com> <201011091433.45387.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011091433.45387.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:33:45PM +0100, Arnd Bergmann wrote:
> On Tuesday 09 November 2010, Geert Uytterhoeven wrote:
> > >
> > > It looks to me like the only arch in the kernel which doesn't support
> > > generic irq is sh.
> > 
> > IIRC, m68k, sparc32, and s390.
> 
> Yes, and among those, no driver in s390 should need asm/irq.h either because
> they do not have interrupt numbers -- every device on s390 has an implicit
> interrupt.
> 
Which is exactly what I stated in my original response. Moving along
then..
