Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab1LOJli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:41:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46996 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab1LOJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:41:37 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 15 Dec 2011 10:41:14 +0100
Message-ID: <CAH9NwWetBZvU6-16rV_s5n=vrAu1kyfsbsjKh+6O2ejf9mM_ww@mail.gmail.com>
Subject: PCI(e) enumeration
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I maintain a debian based linux RFS in my company and my college does the
same for windows. Now we run into a problem that windows and linux use a
different network interface as eth0. In our target system there
are two identical NICs installed.

So I am now looking to find out, how linux does the PCI enumeration
and in which order
the PCI driver gets called to do the initialization. Can somebody tell
me if a depth-first search
or a breadth-first search is done on the PCI bus.


For instance look at this lspci output:

00:01.0 Host bridge: Advanced Micro Devices [AMD] CS5536 [Geode
companion] Host Bridge (rev 33)
00:01.1 VGA compatible controller: Advanced Micro Devices [AMD] Geode LX Video
00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD]
Geode LX AES Security Block
00:04.0 Ethernet controller: Intel Corporation 8255xER/82551IT Fast
Ethernet Controller (rev 10)
00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode
companion] ISA (rev 03)
00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode
companion] IDE (rev 01)
00:0f.3 Multimedia audio controller: Advanced Micro Devices [AMD]
CS5536 [Geode companion] Audio (rev 01)
00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
companion] OHC (rev 02)
00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
companion] EHC (rev 02)
00:0f.7 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
companion] UOC (rev 02)

How will linux does the enumeration?

thanks
--
Christian Gmeiner, MSc
