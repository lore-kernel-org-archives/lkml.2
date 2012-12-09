Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab2LITjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:39:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40634 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2LITjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:39:40 -0500
MIME-Version: 1.0
Date: Sun, 9 Dec 2012 20:39:38 +0100
Message-ID: <CAPJ9Yc_rcMVqp17MMAb8aBK_y_tY1D_NjTd_6TJP64LemFZY+A@mail.gmail.com>
Subject: Hyper-V storvsc errors with large disk image
From: =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm not subscribed, please CC me)

Hi!

When using huge (13TB) disk images (VHDX, dynamically expanding) with
Hyper-V in Windows 8 Pro and running Linux as guest, I get errors and
hangups when accessing the emulated HD.

dmesg show the following message block looping:

sd 2:0:0:0: [sda]
Sense Key : No Sense [current]
sd 2:0:0:0: [sda]
Add. Sense: No additional sense information
hv_storvsc vmbus_0_1: cmd 0x93 scsi status 0x2 srb status 0x6

I am using the System Rescue CD 3.1.2 alternative 64 bit kernel, uname
-a says: 3.6.9-alt312-amd64

What I do i use parted to create a single partition  and the run
mkfs.ext4 /dev/sda1 on it. the mkfs.ext4 process goes into D+ state
and the mentioned messages start appearing in the kernel log.

Running Window 8 as guest on the same virtual machine works fine, HD
access it without issues.

Bug in the storsvc driver?

Regards,
David
