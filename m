Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1LWJmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:42:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57120 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab1LWJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:42:09 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 09:42:08 +0000
Message-ID: <CAKaSfQB5t4+k2XPpVJzox3mRNAhUi8kdCxeEYk83BJG+kpbj_g@mail.gmail.com>
Subject: kernel Unaligned AIO/DIO on inode EXT4-fs Unaligned AIO/DIO on inode
 by VirtualBox; performance will be poor.
From: Simon Mcnair <simonmcnair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Sorry for the Newb question but I can't find much clarification of
what this means via google search.  Having seen that it's a generic
kernel error message which just happens to be caused by Virtualbox, I
do not think that Virtualbox is the culprit ?

Dec 20 09:27:24 simon-Vostro1510 kernel: [  345.592265] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 20 15:27:24 simon-Vostro1510 kernel: [21945.601069] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 21 07:58:48 simon-Vostro1510 kernel: [75161.962664] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 21 13:58:48 simon-Vostro1510 kernel: [96762.223676] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 22 11:25:52 simon-Vostro1510 kernel: [173988.954615] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 22 11:25:52 simon-Vostro1510 kernel: [173988.954615] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.
Dec 21 13:58:48 simon-Vostro1510 kernel: [96762.223676] EXT4-fs
(sda5): Unaligned AIO/DIO on inode 3408273 by VirtualBox; performance
will be poor.

root@simon-Vostro1510:/var/log# parted /dev/sda align-check opt 5
5 aligned

Linux simon-Vostro1510 3.0.0-14-generic #23-Ubuntu SMP Mon Nov 21
20:28:43 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

root@simon-Vostro1510:/home/simon/VirtualBox VMs/Win7 64bit# ls -lah
-rw------- 1 simon simon 116G 2011-12-22 20:12 Win7.vmdk

Anything I can do to stop this message ?, a change in virtual disk
file from vmdk to VDI or ...something ?

regards
Simon McNair
