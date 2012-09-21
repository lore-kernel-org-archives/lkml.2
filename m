Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2IUMlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:41:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41862 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2IUMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:41:35 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 14:41:34 +0200
Message-ID: <CAC27Lhfn+o5OWQFs6kvkaheh5cX_6jFxtJadLa8csJcfVknJLQ@mail.gmail.com>
Subject: gma500_gfx black screen
From: Markus H <hauschild.markus@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting a black screen as soon as I am loading the gma500_gfx
driver on a Dell Latitude ST tablet (powered by an Atom Z570, GPU
being a GMA600 with PCIID 8086:40102).
This happens with kernel 3.5.3 (Ubunutu 12.10 beta 1 and with
self-built kernels from gentoo-souces) as well as several other
kernels version past 3.0.
I could not find any indication that this problem has been fixed yet in 3.6rc.

I am currently stuck at trying to debug the issue: I can't read any
output (e.g. from a kernel panic) after typing modprobe gma500_gfx.

I could not setup a serial console that would be useful:
I have to use a USB to serial converter as the tablet has no serial port.
I can't get a serial console at all with the Ubuntu stock kernel
probably because the pl2303 driver is not built into the kernel but
rather loaded as module.
When booting a gentoo system with a kernel that has pl2303 built in I
only get boot messages up to xx kb unused memory has been freed and
nothing after that so I miss the kernel panic (if one happens).
When booting that same system with gma500_gfx built-in I don't get any
output on serial at all, probably because the system hangs before it
has initialized the usb console.


So I have two questions:
1. What other debugging options do I have so I can help with fixing
the gma500_gfx driver.
2. Are there any single commits I could try on top of e.g. a stock
3.2.x kernel to see which one caused this regression?

Greetings,
Markus
