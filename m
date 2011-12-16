Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1LPFvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:51:42 -0500
Received: from tomato.cardboardbox.org.uk ([174.143.157.65]:43147 "EHLO
	tomato.cardboardbox.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab1LPFvl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:51:41 -0500
X-Greylist: delayed 842 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Dec 2011 00:51:41 EST
From: Daniel Palmer <me@danielpalmer.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Porting m68k/nommu to a new board.
Date: Thu, 15 Dec 2011 21:37:29 -0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc4-amd64; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112152137.29195.me@danielpalmer.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm building a custom machine based around a 68sec000 (Fully static 68ec000).
The "board" is a bunch of parts at the moment but I have written a workable 
simulator for the machine which I am using as a testbed for testing things 
like my custom video, DMA controller etc before creating the hardware versions 
in VHDL.

I'm interested in getting mmu-less m68k linux (what used to be known as 
uclinux I guess, seems to be known as m68k/nommu now) running on the simulator 
and later on the real hardware.

>From what I can tell the nommu m68k port is still active. But does it actually 
work? All the details on similar hardware (like the older Palm pilots, Atari 
machines) is pretty ancient, around 2.0. Does anyone have a machine running a 
recent kernel? Were there issues getting it running?

I did a bit of digging in the source and doesn't look like it should be too 
difficult to add the specifics for my machine.. I have a 16550 style UART 
emulated for I/O so I don't need to write a framebuffer driver at the moment.
I'm open to any suggestions people have on how to approach this though.


Please CC me as I'm not subscribed.

Thanks,

Daniel

