Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1BAQ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:27:09 -0500
Received: from science.horizon.com ([71.41.210.146]:35593 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167Ab1BAQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:27:07 -0500
Date: 1 Feb 2011 11:27:03 -0500
Message-ID: <20110201162703.2284.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upgrading to -rc2 (-rc3 is compiling right now), I've been getting
complaints at irregular intervals.  This didn't used to happen with 2.6.37.

It's an old crappy 1.6 GHz P4 (HP Pavilion) with an ASUS P4B266LA
motherboard and a 2001 Award BIOS.

00:00.0 Host bridge [0600]: Intel Corporation 82845 845 [Brookdale] Chipset Host Bridge [8086:1a30] (rev 04)
00:01.0 PCI bridge [0604]: Intel Corporation 82845 845 [Brookdale] Chipset AGP Bridge [8086:1a31] (rev 04)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 05)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801BA ISA Bridge (LPC) [8086:2440] (rev 05)
00:1f.1 IDE interface [0101]: Intel Corporation 82801BA IDE U100 Controller [8086:244b] (rev 05)
00:1f.2 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB Controller #1 [8086:2442] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation 82801BA/BAM SMBus Controller [8086:2443] (rev 05)
00:1f.4 USB Controller [0c03]: Intel Corporation 82801BA/BAM USB Controller #1 [8086:2444] (rev 05)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801BA/BAM AC'97 Audio Controller [8086:2445] (rev 05)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon RV250 If [Radeon 9000] [1002:4966] (rev 01)
01:00.1 Display controller [0380]: ATI Technologies Inc Radeon RV250 [Radeon 9000] (Secondary) [1002:496e] (rev 01)
02:08.0 Ethernet controller [0200]: Intel Corporation 82801BA/BAM/CA/CAM Ethernet Controller [8086:2449] (rev 03)
02:09.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB12LV26 IEEE-1394 Controller (Link) [104c:8020]


Should I bisect this, or does someone know what might be happening?

Thank you!


Jan 30 13:13:25 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 13:13:25 kernel: Do you have a strange power saving mode enabled?
Jan 30 13:13:25 kernel: Dazed and confused, but trying to continue
Jan 30 17:51:10 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 17:51:10 kernel: Do you have a strange power saving mode enabled?
Jan 30 17:51:10 kernel: Dazed and confused, but trying to continue
Jan 30 18:05:11 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 30 18:05:11 kernel: Do you have a strange power saving mode enabled?
Jan 30 18:05:11 kernel: Dazed and confused, but trying to continue
Jan 30 18:19:16 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 30 18:19:16 kernel: Do you have a strange power saving mode enabled?
Jan 30 18:19:16 kernel: Dazed and confused, but trying to continue
Jan 30 18:33:33 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 18:33:33 kernel: Do you have a strange power saving mode enabled?
Jan 30 18:33:33 kernel: Dazed and confused, but trying to continue
Jan 30 18:48:23 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 18:48:23 kernel: Do you have a strange power saving mode enabled?
Jan 30 18:48:23 kernel: Dazed and confused, but trying to continue
Jan 30 21:39:58 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 21:39:58 kernel: Do you have a strange power saving mode enabled?
Jan 30 21:39:58 kernel: Dazed and confused, but trying to continue
Jan 30 22:01:46 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 22:01:46 kernel: Do you have a strange power saving mode enabled?
Jan 30 22:01:46 kernel: Dazed and confused, but trying to continue
Jan 30 22:03:13 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 22:03:13 kernel: Do you have a strange power saving mode enabled?
Jan 30 22:03:13 kernel: Dazed and confused, but trying to continue
Jan 30 22:04:38 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 30 22:04:38 kernel: Do you have a strange power saving mode enabled?
Jan 30 22:04:38 kernel: Dazed and confused, but trying to continue
Jan 30 22:06:03 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 30 22:06:03 kernel: Do you have a strange power saving mode enabled?
Jan 30 22:06:03 kernel: Dazed and confused, but trying to continue
Jan 30 22:07:23 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 30 22:07:23 kernel: Do you have a strange power saving mode enabled?
Jan 30 22:07:23 kernel: Dazed and confused, but trying to continue
Jan 31 01:00:28 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 31 01:00:28 kernel: Do you have a strange power saving mode enabled?
Jan 31 01:00:28 kernel: Dazed and confused, but trying to continue
Jan 31 03:00:02 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 31 03:00:02 kernel: Do you have a strange power saving mode enabled?
Jan 31 03:00:02 kernel: Dazed and confused, but trying to continue
Jan 31 06:27:52 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 31 06:27:52 kernel: Do you have a strange power saving mode enabled?
Jan 31 06:27:52 kernel: Dazed and confused, but trying to continue
Jan 31 07:36:54 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 31 07:36:54 kernel: Do you have a strange power saving mode enabled?
Jan 31 07:36:54 kernel: Dazed and confused, but trying to continue
Jan 31 10:08:08 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 31 10:08:08 kernel: Do you have a strange power saving mode enabled?
Jan 31 10:08:08 kernel: Dazed and confused, but trying to continue
Jan 31 16:42:02 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Jan 31 16:42:02 kernel: Do you have a strange power saving mode enabled?
Jan 31 16:42:02 kernel: Dazed and confused, but trying to continue
Jan 31 20:05:21 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Jan 31 20:05:21 kernel: Do you have a strange power saving mode enabled?
Jan 31 20:05:21 kernel: Dazed and confused, but trying to continue
Feb  1 01:00:19 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 01:00:19 kernel: Do you have a strange power saving mode enabled?
Feb  1 01:00:19 kernel: Dazed and confused, but trying to continue
Feb  1 01:36:42 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 01:36:42 kernel: Do you have a strange power saving mode enabled?
Feb  1 01:36:42 kernel: Dazed and confused, but trying to continue
Feb  1 02:01:04 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 02:01:04 kernel: Do you have a strange power saving mode enabled?
Feb  1 02:01:04 kernel: Dazed and confused, but trying to continue
Feb  1 05:58:05 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 05:58:05 kernel: Do you have a strange power saving mode enabled?
Feb  1 05:58:05 kernel: Dazed and confused, but trying to continue
Feb  1 06:28:18 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 06:28:18 kernel: Do you have a strange power saving mode enabled?
Feb  1 06:28:18 kernel: Dazed and confused, but trying to continue
Feb  1 08:59:18 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 08:59:18 kernel: Do you have a strange power saving mode enabled?
Feb  1 08:59:18 kernel: Dazed and confused, but trying to continue
Feb  1 11:04:43 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:04:43 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:04:43 kernel: Dazed and confused, but trying to continue
Feb  1 11:05:47 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:05:47 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:05:47 kernel: Dazed and confused, but trying to continue
Feb  1 11:06:48 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:06:48 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:06:48 kernel: Dazed and confused, but trying to continue
Feb  1 11:07:50 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:07:50 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:07:50 kernel: Dazed and confused, but trying to continue
Feb  1 11:08:52 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:08:52 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:08:52 kernel: Dazed and confused, but trying to continue
Feb  1 11:09:54 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:09:54 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:09:54 kernel: Dazed and confused, but trying to continue
Feb  1 11:10:56 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:10:56 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:10:56 kernel: Dazed and confused, but trying to continue
Feb  1 11:11:58 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:11:58 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:11:58 kernel: Dazed and confused, but trying to continue
Feb  1 11:13:00 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:13:00 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:13:00 kernel: Dazed and confused, but trying to continue
Feb  1 11:14:01 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:14:01 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:14:01 kernel: Dazed and confused, but trying to continue
Feb  1 11:15:04 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:15:04 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:15:04 kernel: Dazed and confused, but trying to continue
Feb  1 11:16:05 kernel: Uhhuh. NMI received for unknown reason 3d on CPU 0.
Feb  1 11:16:05 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:16:05 kernel: Dazed and confused, but trying to continue
Feb  1 11:17:07 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:17:07 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:17:07 kernel: Dazed and confused, but trying to continue
Feb  1 11:18:33 kernel: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Feb  1 11:18:33 kernel: Do you have a strange power saving mode enabled?
Feb  1 11:18:33 kernel: Dazed and confused, but trying to continue
