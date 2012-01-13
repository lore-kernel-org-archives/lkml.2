Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2AMN1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:27:05 -0500
Received: from smtp.nokia.com ([147.243.1.48]:62478 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2AMN1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:27:04 -0500
Message-ID: <1326461140.32183.40.camel@groo>
Subject: [GIT PULL] HSI framework
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>, artem.bityutskiy@linux.intel.com,
        Andras Domokos <andras.domokos@nokia.com>,
        ext Shubhrajyoti <shubhrajyoti@ti.com>,
        ext Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 13 Jan 2012 15:25:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have been working in an HSI framework. The High Speed Synchronous Serial Interface (HSI) is a serial interface mainly used for connecting application engines (APE) with cellular modem engines (CMT) in cellular handsets.

The framework is currently being used for some people and we would like to see it integrated into the kernel for 3.3. There is no HW controller drivers in this pull, but some people have already some of them pending which they would like to push as soon as this integrated. I am also working on the acceptance for an TI OMAP one, based on a compatible legacy version of the interface called SSI.

Please see the latest discussion thread about the framework patches here:

https://lkml.org/lkml/2011/6/10/280

Here thread discussion for integration:

https://lkml.org/lkml/2011/10/20/177

Here, the thread discussion to add the hsi repository to linux-next:

https://lkml.org/lkml/2011/10/28/69

The patches have been sitting for a while in linux-next without issues.

The signed tag covering those commits: hsi_for_3.3 

Thanks & Br,
Carlos Chinea

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://gitorious.org/kernel-hsi/kernel-hsi.git for-next

Andras Domokos (3):
      HSI: hsi_char: Add HSI char device driver
      HSI: hsi_char: Add HSI char device kernel configuration
      HSI: hsi_char: Update ioctl-number.txt

Carlos Chinea (2):
      HSI: hsi: Introducing HSI framework
      HSI: Add HSI API documentation

 Documentation/DocBook/device-drivers.tmpl |   17 +
 Documentation/ioctl/ioctl-number.txt      |    1 +
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/hsi/Kconfig                       |   19 +
 drivers/hsi/Makefile                      |    6 +
 drivers/hsi/clients/Kconfig               |   13 +
 drivers/hsi/clients/Makefile              |    5 +
 drivers/hsi/clients/hsi_char.c            |  802 +++++++++++++++++++++++++++++
 drivers/hsi/hsi.c                         |  494 ++++++++++++++++++
 drivers/hsi/hsi_boardinfo.c               |   62 +++
 drivers/hsi/hsi_core.h                    |   35 ++
 include/linux/Kbuild                      |    1 +
 include/linux/hsi/Kbuild                  |    1 +
 include/linux/hsi/hsi.h                   |  410 +++++++++++++++
 include/linux/hsi/hsi_char.h              |   63 +++
 16 files changed, 1932 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hsi/Kconfig
 create mode 100644 drivers/hsi/Makefile
 create mode 100644 drivers/hsi/clients/Kconfig
 create mode 100644 drivers/hsi/clients/Makefile
 create mode 100644 drivers/hsi/clients/hsi_char.c
 create mode 100644 drivers/hsi/hsi.c
 create mode 100644 drivers/hsi/hsi_boardinfo.c
 create mode 100644 drivers/hsi/hsi_core.h
 create mode 100644 include/linux/hsi/Kbuild
 create mode 100644 include/linux/hsi/hsi.h
 create mode 100644 include/linux/hsi/hsi_char.h


