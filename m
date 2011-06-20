Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1FTFpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:18 -0400
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:35233
	"EHLO qmta09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1FTFpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:16 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/22] staging: usbip: misc. userspace changes
Date: Sun, 19 Jun 2011 22:44:30 -0700
Message-Id: <cover.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch set contains only userspace changes. Next, I will take a look at
attach and detach, which should soon lead to the reason why usbip is not
currently working.

Thanks,
matt

matt mooney (22):
  staging: usbip: userspace: update cleanup.sh
  staging: usbip: userspace: usbip_common.h: cleanup log macros
  staging: usbip: userspace: usbip_common.h: move enums
  staging: usbip: userspace: usbip_common.h: fixup header includes
  staging: usbip: userspace: libsrc: set program name for logging
  staging: usbip: userspace: usbip.c: add log option
  staging: usbip: userspace: libsrc: remove usbip.h
  staging: usbip: userspace: libsrc: change all output messages to
    debug
  staging: usbip: userspace: usbip: modify command failure
  staging: usbip: userspace: utils: remove libsysfs circumvention
  staging: usbip: userspace: utils.c: rewrite modify_match_busid
  staging: usbip: userspace: usbip_bind.c: major rewrite of the
    implementation
  staging: usbip: userspace: usbip_unbind.c: implement using libsysfs
  staging: usbip: userspace: usbip list: edit output messages
  staging: usbip: userspace: usbip list: move output header
  staging: usbip: userspace: rename stub driver files
  staging: usbip: userspace: usbip_host: update function and variable
    names
  staging: usbip: userspace: usbipd: major cleanup of daemon
  staging: usbip: userspace: usbip_network.c: coding style cleanup
  staging: usbip: userspace: add new prefix for usbip network code
  staging: usbip: userspace: fix header installation bug
  staging: usbip: userspace: configure.ac: change package data

 drivers/staging/usbip/userspace/Makefile.am        |    4 +-
 drivers/staging/usbip/userspace/cleanup.sh         |   10 +-
 drivers/staging/usbip/userspace/configure.ac       |    2 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    8 +-
 .../staging/usbip/userspace/libsrc/stub_driver.c   |  390 -----------
 .../staging/usbip/userspace/libsrc/stub_driver.h   |   36 -
 drivers/staging/usbip/userspace/libsrc/usbip.h     |   19 -
 .../staging/usbip/userspace/libsrc/usbip_common.c  |   19 +-
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  118 ++--
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  401 +++++++++++
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   48 ++
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   99 ++--
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   13 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |    6 +-
 drivers/staging/usbip/userspace/src/usbip.c        |   26 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |    8 +-
 drivers/staging/usbip/userspace/src/usbip_bind.c   |  303 +++++----
 drivers/staging/usbip/userspace/src/usbip_list.c   |   81 ++-
 .../staging/usbip/userspace/src/usbip_network.c    |  121 ++--
 .../staging/usbip/userspace/src/usbip_network.h    |   39 +-
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  123 +++-
 drivers/staging/usbip/userspace/src/usbipd.c       |  697 ++++++++++----------
 drivers/staging/usbip/userspace/src/utils.c        |  317 ++--------
 drivers/staging/usbip/userspace/src/utils.h        |   31 +-
 24 files changed, 1417 insertions(+), 1502 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h

-- 
1.7.5.2

