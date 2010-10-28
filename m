Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0J1Tq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0J1Tqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:46:51 -0400
Message-ID: <4CC9D31F.4080404@redhat.com>
Date: Thu, 28 Oct 2010 17:46:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <shijie8@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Firmware for Telgent 2300 V4L/DVB driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Huang sent me a firmware file for Telgent 2300 some time ago, with the proper
redistribution rights from the manufacturer. Not sure why, but it seems that 
I forgot to add on my linux-next tree and to ask you to pull from it.

So, please pull it from my tree:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Thanks,
Mauro

---

The following changes since commit e9f9e3a9b7d780e93ae869c1b8502c843bfd93a4:

  wimax: update WiMAX firmwares for 2.6.35 (2010-09-29 12:02:34 +0900)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Mauro Carvalho Chehab (1):
      Add firmware for Telgent 2300 V4L/DVB driver

 WHENCE               |   16 ++++++++++++++++
 tlg2300_firmware.bin |  Bin 0 -> 51972 bytes
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 tlg2300_firmware.bin
