Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0KIHgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 02:36:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50932 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752320Ab0KIHgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 02:36:19 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+m3g5fRNum3qqynkkCgFJkFN4+bLKbEq7pYFchPa
	n9rxDoJDl6HsoK
Date: Tue, 9 Nov 2010 08:36:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alexey Charkov <alchark@gmail.com>
cc: Paul Mundt <lethal@linux-sh.org>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v4] ARM: Add support for the display controllers in
 VT8500 and WM8505
In-Reply-To: <AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1011090833310.25364@axis700.grange>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
 <1289147348-31969-6-git-send-email-alchark@gmail.com> <20101108041721.GA11605@linux-sh.org>
 <20101108141407.GA25739@alchark-u3s.lan> <20101108204315.GA12050@linux-sh.org>
 <AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com>
 <20101108213008.GB17708@linux-sh.org> <20101108234239.GA20819@alchark-u3s.lan>
 <20101108235407.GB18385@linux-sh.org> <AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Alexey Charkov wrote:

> 2010/11/8 Paul Mundt <lethal@linux-sh.org>:
> > On Tue, Nov 09, 2010 at 02:42:39AM +0300, Alexey Charkov wrote:
> >> From 95942cc0cd0909d700c236ba63d3488ec9fccf1a Mon Sep 17 00:00:00 2001
> >> From: Alexey Charkov <alchark@gmail.com>
> >> Date: Tue, 9 Nov 2010 02:25:40 +0300
> >> Subject: [PATCH 3/3] ARM: Add support for the display controllers in VT8500 and WM8505
> >>
> >> This adds drivers for the LCD controller found in VIA VT8500 SoC,
> >> GOVR display controller found in WonderMedia WM8505 SoC and for the
> >> Graphics Engine present in both of them that provides hardware
> >> accelerated raster operations (used for copyarea and fillrect).
> >>
> >> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> >> ---
> >>
> >> This incorporates fixes to the issues last mentioned by Paul.
> >>
> >> I just dropped <asm/irq.h>, as that seems to be not used at all currently
> >> (must have been some old cut-and-paste as well). As for the Graphics
> >> Engine, I decided not to disable it for now at device exit time, at least
> >> until we reach a conclusion on how or whether to implement support for its
> >> alpha-mixing capabilities. Unlike with display drivers, this should have no
> >> user-visible consequences. This can be changed later, when time comes for
> >> device clocks and power management support.
> >>
> > Looks good to me!
> >
> > Reviewed-by: Paul Mundt <lethal@linux-sh.org>
> >
> 
> Thanks, Paul!
> 
> Is there anybody I should address specifically to get this merged?

In the absence of a fbdev maintainer, such patches, as long as they don't 
touch the core, apart from the obvious and trivial Makefile and Kconfig 
hunks, they normally get mainlined via respective arch trees, i.e., you 
can just push them the same way as your other SoC patches. OTOH you can 
also ask Andrew Morton to pull them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
