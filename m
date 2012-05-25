Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2EYGHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:07:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33708 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2EYGHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:07:19 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 14:07:19 +0800
Message-ID: <CABawtvNr9KGhjK-pY06C2ovphNb=Qjjtwc50ObNzpLmxD1DCQQ@mail.gmail.com>
Subject: [Bug] Can't bring up stable kernel 3.3.7 with 4TB memory
From: ethan zhao <ethan.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
    After compiled and installed the stable kernel 3.3.7 onto my 4TB
memory machine,  Got following errors and can't boot to normal status,
But some old version kernel boot OK without such errors, such as 3.0.3
/3.0.26 etc. So not sure it is BIOS bug,  regression ?


root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /vmlinuz-3.3.7 ro root=/dev/vg0/lv0 rhgb quiet console=ttyS0
  [Linux-bzImage, setup=0x3e00, size=0x3ebe20]
initrd /initrd-3.3.7.img



LAPIC pending interrupts after 512 EOI
..MP-BIOS bug: 8254 timer not connected to IO-APIC
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
APIC delivery error (ef).
APIC never delivered???
