Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1CGSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:24:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38712 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1CGSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:24:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=BLEN50WWRnZZ8WHXNngKtFM2ZHvlYJ05CJKe12QXdf3X5iw2pwGgBBm4C6NixwDSfd
         K04OCci1URldHqNW3KCdq1i10Ve2fYAt+2ZQbmTx+YIWMEcvypt2qU79C5nxFUHcweY+
         wd7/e8rW1MaUl3AymgH98ASHf2M3/Cc9EfyeQ=
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Mon, 7 Mar 2011 21:53:55 +0330
Message-ID: <AANLkTinqJzy8XJGXd=M7fMixbu+M-1OY3G5U=nKTSp7H@mail.gmail.com>
Subject: Question about using Qemu and Eclipse CDT for debugging kernel
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I use Qemu and Eclipse CDT debugging tool for debugging kernel. I
installed ubuntu 10.04 on a Qemu image disk.  Now I use following
command to run qemu ubuntu disk image with my kernel(2.6.32.29) : sudo
qemu -s -S -hda ubuntu-qemu-test -append "root=/dev/sda1" -kernel
/mnt/build/linux-2.6/arch/x86/boot/bzImage
My problem is, after eclipse started debugging, and qemu boots ubuntu,
mouse is hidden, but when I run ubuntu on Qemu with his own
kernel(using this command: qemu ubuntu-qemu-test), I don't encounter
this problem.
In addition, I use unmodified version of kernel 2.6.32.29 now. After
this step, I will put my own code(My new IO scheduler) in kernel.

Anyone's guidance is appreciated.

p.s
Before Ubuntu, I used ready image disk on Qemu's site:
linux-0.2.img.bz2 (Small Linux disk image containing a 2.6.20 Linux
kernel, X11 and various utilities to test QEMU ) which is a very small
linux with very restricted facilities and no GUI. Since I intended to
use benchmarks to evaluate my code, and I encountered some problems in
installing packages,I decided not to use it.

This is a part of my B.S thesis and I'm frozen in this step!! your
help will be so admirable for me.

Regards,


-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
