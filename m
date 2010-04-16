Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0DPR2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:28:22 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9867 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0DPR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:28:21 -0400
X-RZG-AUTH: :Jm0KVUSnfvMjmR9git3O5c6quLOX9IapxonCLJShzDbee41FJdtkx5o=
X-RZG-CLASS-ID: mo00
From: linux-media@jd67.de
To: linux-kernel@vger.kernel.org
Subject: Nova-T USB-Stick Model 1277: DiB0070 I2C read / write failed
Date: Fri, 16 Apr 2010 19:26:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-4-686-bigmem; KDE/4.3.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004161926.17040.linux-media@jd67.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some trouble with a Nova-T USB-Stick. 

It's a "WinTV NOVA-T Stick Value, Model 1277" USB-ID:2040:7070.

I use three of it with an ASRock 939A785GMH/128M Mainboard (AMD A785 / SB710) as an Myth-Server.

Currently everything running fine after following all advices found at:
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-Stick (Making it Work).

At the modules
* Disabled dvb-rec-polling
* Enabled LNA 
* Additional Disabled usb-suspend.

At Myth-Backend
* Disabled all EIT-scans 
* set an tuning delay to 1000ms.

Before I changing mythtv, I had errors like:

Apr 13 15:58:07 vdr1 kernel: [ 1887.816045] dvb-usb: error while stopping stream.
Apr 13 15:58:13 vdr1 kernel: [ 1893.137037] dvb-usb: error while enabling fifo.
Apr 13 15:59:38 vdr1 kernel: [ 1978.672048] dvb-usb: error while stopping stream.
Apr 13 16:00:18 vdr1 kernel: [ 2018.165037] DiB0070 I2C write failed
Apr 13 16:00:23 vdr1 kernel: [ 2023.176044] DiB0070 I2C read failed
Apr 13 16:00:26 vdr1 kernel: [ 2026.468132] DiB0070 I2C write failed

Before I disabled the dvb-rec-polling, I had usb-fullstops:

ehci_hcd 0000:00:13.2: force halt; handhake f804c424 00004000 00000000 -> -110

I tested with ubuntu-kernels 2.6.31, 32 and 33. 

I can live with this settings, but I have some bad feeling going in holiday for a longer while, leaving the system 
alone. Is there anything I can do, help fixing this issues. Enable debug options, sending logs?

Would it help, to use an other usb-chipset (VIA, etc)?

Greetings from Frankfurt
Jan





