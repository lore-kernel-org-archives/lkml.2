Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0GDWbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 18:31:38 -0400
Received: from lo.gmane.org ([80.91.229.12]:48854 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab0GDWbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 18:31:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "H.S." <hs.samix@gmail.com>
Subject: Linux support for AM3 socket Asus M4A87TD EVO (chipset AMD 870 /
 SB850) motherboard
Date: Sun, 04 Jul 2010 18:31:24 -0400
Message-ID: <i0r23t$sqj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 206-248-185-17.dsl.teksavvy.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Lightning/1.0b1 Icedove/3.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am thinking of getting this motherboard, AM3 socket Asus M4A87TD EVO.
It appears to be a new one from Asus and I am wondering if Linux
supports it in all ways (networking, sound, etc.).

Chipset: AMD 870 / SB850

LAN: RTL8111E PCIe Gigabit LAN controller featuring AI NET2

Audio: VT1818 High Definition Audio 8-Channel CODEC

Storage: SB850 Chipset. 6 xSATA 6.0 Gb/s ports Support RAID 0,1,5,10
IEEE 1394: VIA® VT6308P controller supports 2 x 1394a port(s)

USB:
  NEC® USB 3.0 controller:- 2 x USB 3.0/2.0 ports (blue; at back panel)
  SB850 Chipset:- 12 x USB 2.0 ports (6 ports at mid-board, 6 ports at
back panel)


>From some google search, it appears that gigabit LAN has some problems
on wake-on-lan with the default linux driver, but the module compiled
from the manufacturer's source code works properly (but if wake-on-lan
is not to be used, the linux driver works okay). Some people have also
had problems making the audio work, but I can't confirm one way or the
other. No word regarding USB 3.0. The new SATA, 6 Gbps, seems to work
since some people have installed linux on it. But these issue are
apparently a few months old.

Can anybody with this mobo confirm that it is working fully in Linux?

Thanks.

-- 

Please reply to this list only. I read this list on its corresponding
newsgroup on gmane.org. Replies sent to my email address are just
filtered to a folder in my mailbox and get periodically deleted without
ever having been read.

