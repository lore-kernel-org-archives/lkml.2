Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1ENKz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:55:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:39041 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1ENKz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nb8E4XOwaUsuvQ/NaaiSrhtCnxfziE/2RNfQX1jr21bxc3VsCI+j4hYh2QcTWzBhER
         XCd5nmJIjC3lORJLQ1ce/USyEHNYk7WYHaBCICqDhacnIwaeEFkTF3PXcQ2ESKNBMoZp
         oa5AkBneZSzNily4KOWhSZ+b97idxItRhZoOw=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] staging: usbip: userspace code
Date: Sat, 14 May 2011 03:55:06 -0700
Message-Id: <cover.1305369175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Hi Greg,

Well, here is the userspace code! Let me know what you think. For the
source tarball, I chose to add one target with the kernel version,
but I am thinking that maybe having `git rev-parse --short HEAD' or
something as part of the name would be more useful. I guess that may
not matter though depending on how the userspace utilities are
versioned.

Thanks,
matt

matt mooney (14):
  staging: usbip: add userspace code
  staging: usbip: userspace: move manpages to separate directory
  staging: usbip: userspace: rename source directories
  staging: usbip: userspace: remove unused files
  staging: usbip: userspace: whitespace cleanup
  staging: usbip: userspace: update module name references
  staging: usbip: userspace: configure.ac: major overhaul
  staging: usbip: userspace: cleanup makefiles
  staging: usbip: userspace: set libusbip version in configure.ac
  staging: usbip: userspace: remove revision $Id$
  staging: usbip: userspace: remove gcc warnings
  staging: usbip: userspace: move common cflags to configure.ac
  staging: usbip: userspace: modify project gcc flags
  package: Makefile: add USB/IP userspace utilities

 drivers/staging/usbip/userspace/AUTHORS            |    2 +
 drivers/staging/usbip/userspace/COPYING            |  340 +
 drivers/staging/usbip/userspace/INSTALL            |  237 +
 drivers/staging/usbip/userspace/Makefile.am        |   11 +
 drivers/staging/usbip/userspace/README             |  215 +
 drivers/staging/usbip/userspace/autogen.sh         |    9 +
 drivers/staging/usbip/userspace/cleanup.sh         |   10 +
 drivers/staging/usbip/userspace/configure.ac       |  114 +
 drivers/staging/usbip/userspace/doc/usbip.8        |   71 +
 .../usbip/userspace/doc/usbip_bind_driver.8        |   42 +
 drivers/staging/usbip/userspace/doc/usbipd.8       |   62 +
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    7 +
 drivers/staging/usbip/userspace/libsrc/names.c     |  793 ++
 drivers/staging/usbip/userspace/libsrc/names.h     |   57 +
 .../staging/usbip/userspace/libsrc/stub_driver.c   |  390 +
 .../staging/usbip/userspace/libsrc/stub_driver.h   |   36 +
 drivers/staging/usbip/userspace/libsrc/usbip.h     |   19 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  282 +
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  149 +
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  506 +
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   61 +
 drivers/staging/usbip/userspace/src/Makefile.am    |   10 +
 drivers/staging/usbip/userspace/src/bind-driver.c  |  643 +
 drivers/staging/usbip/userspace/src/usbip.c        |  723 ++
 .../staging/usbip/userspace/src/usbip_network.c    |  251 +
 .../staging/usbip/userspace/src/usbip_network.h    |  198 +
 drivers/staging/usbip/userspace/src/usbipd.c       |  570 +
 drivers/staging/usbip/userspace/src/utils.c        |  255 +
 drivers/staging/usbip/userspace/src/utils.h        |   38 +
 drivers/staging/usbip/userspace/usb.ids            |13209 ++++++++++++++++++++
 scripts/package/Makefile                           |   15 +-
 31 files changed, 19324 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/usbip/userspace/AUTHORS
 create mode 100644 drivers/staging/usbip/userspace/COPYING
 create mode 100644 drivers/staging/usbip/userspace/INSTALL
 create mode 100644 drivers/staging/usbip/userspace/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/README
 create mode 100755 drivers/staging/usbip/userspace/autogen.sh
 create mode 100755 drivers/staging/usbip/userspace/cleanup.sh
 create mode 100644 drivers/staging/usbip/userspace/configure.ac
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbipd.8
 create mode 100644 drivers/staging/usbip/userspace/libsrc/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.h
 create mode 100644 drivers/staging/usbip/userspace/src/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/src/bind-driver.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.h
 create mode 100644 drivers/staging/usbip/userspace/src/usbipd.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.h
 create mode 100644 drivers/staging/usbip/userspace/usb.ids

-- 
1.7.5.1

