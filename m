Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1BIWBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:01:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1BIWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=HB51po/gdxLr+SaHirzC/UHiq5F0rp5Wuon6+/0UTShHtlioHqn8d8uZVGofjhx/Gk
         gZC00cBNla9jPPXlJ5i8cVPqNFFjuqX2Vp+5S/wuUziYEURzpFNmCOXI7BUorhxv0W8+
         8rV6H0rxkRKCVilnRvgEHt7VoxC8c3MwuSts4=
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Thu, 10 Feb 2011 01:30:56 +0330
Message-ID: <AANLkTin20CuVOpK25TTCD=195Fqktre2zWCbwC+2SPHX@mail.gmail.com>
Subject: ubuntu boot problem after compiling new kernel
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I compiled a new kernel according to
http://www.howtoforge.com/kernel_compilation_ubuntu instructions. The
kernel version is 2.6.18.1 and I did it in ubuntu 10.04 installed on
Virtualbox. But by choosing this kernel at grub, it gives this error:

libudev: udev_monitor_new_from_netlink: error getting socket: Invalid argument
Segmentation fault
Gave up waiting for root device. common problems:
-Boot args (cat /proc/cmdline)
    -check rootdelay=(did the system wait long enough?)
    -check root=(did the system wait for the right device?)
-Missing modules (cat /proc/modules:  ls /dev)
ALERT! /dev/sda1 does not exist. Dropping to a shell!

I googled it and I looked for solution in many forums. I found some
solutions, but none of them worked for me :(
Such as checking if root device in grub is right for this kernel...
adding rootdelay=...  to kernel line ... update-initramfs, adding
all_generic_ide to kernel line,...

My main kernel version is 2.6.32.21

Your help is appreciated. It's more than a week that I'm looking for a
solution. :-s


-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
