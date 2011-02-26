Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1BZMs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 07:48:56 -0500
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:48395 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab1BZMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 07:48:55 -0500
X-Greylist: delayed 1389 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Feb 2011 07:48:55 EST
MIME-Version: 1.0
From: Alvaro Aguilera <alvaro.aguilera@mailbox.tu-dresden.de>
Date: Sat, 26 Feb 2011 13:25:24 +0100
Message-ID: <AANLkTimtj=8ikdzgUiaT+y1MsjfGNU3LcyaUMPU0wMEh@mail.gmail.com>
Subject: Question about the vmlinuz file
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

perhaps someone here has a couple of minutes to explain me the
difference between these two vmlinuz files from different
distributions:

$file /boot/vmlinuz
/boot/vmlinuz-2.6.37-40-desktop: Linux/x86 Kernel, Setup Version
0x20a, bzImage, Version 2.6.37, Version 2.6.37-40, RO-rootFS, root_dev
0x301, swap_dev 0x4, Normal VGA

$file /boot/vmlinuz
vmlinuz: ELF 64-bit LSB shared object, AMD x86-64, version 1, stripped

the second file seems to be in ELF format and I cannot use it with my
cluster management software.

Is there a parameter I can use to compile the kernel image in one
format or the other? or a tool to convert them?

I couldn't find any hint on Google, nor I really know what exactly to look for.

Thanks for any help.
Alvaro.
