Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab1FCVoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:44:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47279 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1FCVoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:content-type:message-id:date:to
         :content-transfer-encoding:mime-version:x-mailer;
        b=t14UlP8qr7Ay0fnwLGnA31OAS2AvRnYfK3gSmMEyFqS5wtRQZu/0eXKDhkbIgTXm+n
         1I3d49WY0Oetd4Ud+BNZBRD6LFtTXshEzNmw3PeCq6TEDsL/M/8ejuJk0p0zxbKG743O
         WIXWbK3mEP8y4bwYaYb1Cfc1wTCt58+ylecdg=
Subject: rcu_kthread hang on 3.0.0-rc1-next-20110602
From: =?iso-8859-1?Q?Markus_H=E4stbacka?= <mhastbacka@gmail.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <85F46CF9-5433-4623-91FC-9CD890082F69@gmail.com>
Date: Sat, 4 Jun 2011 00:43:25 +0300
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

After updating my debian squeeze box to 3.0.0-rc1-next-20110602 I'm experiencing a weird problem. If I run dmesg  the computer hangs for 15 minutes, and I cannot even login at this time, if I leave top (the top window updates very slowly, like every 5 minutes during this period) running I can see that the process rcu_kthread takes 100% CPU, the computer load average is at around 10.

I also sometimes get these disk errors in syslog:
Jun  4 02:01:39 midi3g kernel: ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
Jun  4 02:01:39 midi3g kernel: ata1.01: BMDMA stat 0x44
Jun  4 02:01:39 midi3g kernel: ata1.01: failed command: WRITE DMA
Jun  4 02:01:39 midi3g kernel: ata1.01: cmd ca/00:00:1c:7b:c6/00:00:00:00:00/f0 tag 0 dma 131072 out
Jun  4 02:01:39 midi3g kernel:         res 51/84:00:fe:7b:c6/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)
Jun  4 02:01:39 midi3g kernel: ata1.01: status: { DRDY ERR }
Jun  4 02:01:39 midi3g kernel: ata1.01: error: { ICRC ABRT }
Jun  4 02:01:39 midi3g kernel: ata1: soft resetting link
Jun  4 02:01:39 midi3g kernel: ata1.01: configured for UDMA/66
Jun  4 02:01:39 midi3g kernel: ata1: EH complete

but for example the last time I got the hang, I didn't get this error, nor any other error for that matter.

The OS is installed on a CF-card. The computer is a eBox computer with VIA Nehemiah CPU, 256MB RAM.

what more information do you need? Or what more can I test?

M


