Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0JZOy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:54:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38760 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CDUVqmqGLG/xWyMv2sqtf85FDOlm00dlN+KZKQruResS98XraAL9b9msF/DT+vrnFy
         5m5dmsRE6zeOlcTZ6lITfl/ele4xuq72ZP1zYaMOvRH+5+3MNz6virRarnu6d95pb2z8
         BsfXOyGRo46yBztvOa8luGWoV+QL7HfTc/UeM=
MIME-Version: 1.0
Date: Tue, 26 Oct 2010 20:24:23 +0530
Message-ID: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
Subject: ALSA sound/pci/hda/hda_intel.c:2624: no codecs found
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Audio is not working with new Intel WX58BP Motherboard :

[    4.843163] IOAPIC[0]: Set routing entry (8-22 -> 0xa9 -> IRQ 22
Mode:1 Active:1)
[    4.843168] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    4.861627] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    4.861645] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.866678] ALSA sound/pci/hda/hda_intel.c:2624: no codecs found!
[    4.876300] HDA Intel 0000:00:1b.0: PCI INT A disabled
[    4.885826] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    4.905269] HDA Intel 0000:02:00.1: irq 47 for MSI/MSI-X
[    4.905282] HDA Intel 0000:02:00.1: setting latency timer to 64
[    4.909136] ALSA device list:
[    4.918895]   #0: HDA ATI HDMI at 0xd0110000 irq 47

dmesg : http://userweb.kernel.org/~jaswinder/Corei7/dmesg_b18cae4224b.txt
config : http://userweb.kernel.org/~jaswinder/Corei7/configs_b18cae4224b.txt

$ lspci | grep Audio
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
02:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon
HD 34xx Series]

lspci : http://userweb.kernel.org/~jaswinder/Corei7/lspci.txt

If more information is needed, please let me know.

Thanks,
--
Jaswinder Singh.
