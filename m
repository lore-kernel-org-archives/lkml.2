Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0IKJm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:42:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0IKJmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tRItXhj8qWI6qDI8Wq0Qa3yJ5t+mXezMAUOosCiDe5zVmUWUv0Arkbz6pT94UX41KF
         nGk4QspoJEPmWrPSSsNbtpAWTFd3ijz+tSAtac5ejsyN+MxmAvMnBAfbbLiW6RnPz+rX
         vs+JsutbnF1emW8/6RCOujNBlsjN1y2oo+K30=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 15:12:23 +0530
Message-ID: <AANLkTimMxQXxC354V=qVOrdUYFSrpJ-RZeKJfQEx0KPN@mail.gmail.com>
Subject: How to determine the information about SATA controller
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My old IDE hard disk is broken so I installed new SATA drive on my box with F13:

dmesg :
http://userweb.kernel.org/~jaswinder/P4_HT/dmesg_2633_fc13.txt

lsmod:
http://userweb.kernel.org/~jaswinder/P4_HT/lsmod_2633_fc13.txt

lspci:
00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
Controller/Host-Hub Interface (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated
Graphics Controller (rev 02)
00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to
I/O Memory Interface (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)

I am trying to build the kernel with this config:
http://userweb.kernel.org/~jaswinder/P4_HT/config-ht-test.txt

But I am getting error :

No root device found.
Boot has failed, sleeping forever

I am trying to determine the information about the SATA controller so
that I can choose the appropriate controller for SATA in kernel
config. I am not able to figure out the SATA information from above
dmesg and lsmod. How can I do so.

Thanks,
--
Jaswinder Singh.
