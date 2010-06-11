Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab0FKI5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:57:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44644 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab0FKI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=OlbkrIqrqc7MH78GYyRg/85vtoj3g7rZNus04oT7g7rfLT483boo8OqUQ9MKDKJgDH
         4ZqvD1gPuKuFRkME5PCTU2GnA0lUmLHbPYzXN02Jwr9L/R5piIcYNahPuwmF1EJIOxK3
         lheZONXlMspsCGjvkKK7ReYr43wLv9YphnL+A=
From: Eric Lacombe <goretux@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Subject: [BUG ?] Nouveau driver on 330M GT
Date: Fri, 11 Jun 2010 10:52:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-custom; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111052.29187.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested Nouveau with 2.6.34, and now with 2.6.35-rc2 and It does not work 
with my laptop (chip NVIDIA GeForce 330M GT). (I give more information of the 
nvidia chip below). I've seen an error message related to my nvidia chip that 
may also be related to my problem :

pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]

Thanks in advance for your response.

Best regards

	Eric

Here more information :

# dmesg |grep "01\:00\.0"
[    0.933105] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd0ffffff]
[    0.933122] pci 0000:01:00.0: reg 14: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.933139] pci 0000:01:00.0: reg 1c: [mem 0xb0000000-0xb1ffffff 64bit pref]
[    0.933151] pci 0000:01:00.0: reg 24: [io  0x6000-0x607f]
[    0.933166] pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
[    0.957777] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.973672] pci 0000:01:00.0: no compatible bridge window for [mem 
0xfff80000-0xffffffff pref]
[    0.973800] pci 0000:01:00.0: BAR 6: assigned [mem 0xd1080000-0xd10fffff 
pref]
[   13.092806] vgaarb: transferring owner from PCI:0000:00:02.0 to 
PCI:0000:01:00.0


# sudo lspci -v -s 0000:01:00.0
01:00.0 VGA compatible controller: nVidia Corporation Device 0a2b (rev a2)
        Subsystem: Sony Corporation Device 905a
        Flags: fast devsel, IRQ 5
        Memory at d0000000 (32-bit, non-prefetchable) [disabled] [size=16M]
        Memory at a0000000 (64-bit, prefetchable) [disabled] [size=256M]
        Memory at b0000000 (64-bit, prefetchable) [disabled] [size=32M]
        I/O ports at 6000 [disabled] [size=128]
        Expansion ROM at d1080000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 3
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint, MSI 00
        Capabilities: [b4] Vendor Specific Information <?>
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [128] Power Budgeting <?>
        Capabilities: [600] Vendor Specific Information <?>
        Kernel modules: nouveau, nvidiafb
