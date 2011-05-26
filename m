Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab1EZNRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:17:24 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42105 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab1EZNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:23 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] usbip: userspace improvements
Date: Thu, 26 May 2011 06:17:07 -0700
Message-Id: <cover.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here is a series to go in your queue until you have time to look at
them and open up your tree for patches. The major patch in the series
is userspace tools v1.0.0. There is a _lot_ of work left to improve
the userspace stuff, but this is what I think is a big step in the
right direction, which will lead into major work in the kernel code.

I would also like to let you guys know (Arjan!) that I am working on
a draft of a protocol for usbip. This will attempt to provide a
well-defined and unified userspace and kernel protocol, along with
providing some documentation of what usbip is doing, which seems to be
in high demand. The goal is to have interoperability between different
systems without the need to have the same implementation. I will post
a draft soon so that everyone interested can help me refine it.
Unfortunately, I am going out of town for the next few days, so I am
not exactly sure when that will be.

Thanks,
matt


matt mooney (6):
  staging: usbip: userspace: set kernel module names in one place
  staging: usbip: userspace: change struct class_device to
    usbip_class_device
  staging: usbip: userspace: vhci_driver: parameterize path names
  staging: usbip: userspace tools v1.0.0
  staging: usbip: userspace: usbipd.c: add header into source file
  staging: usbip: userspace: usbip_network: rename and cleanup function

 drivers/staging/usbip/userspace/configure.ac       |    4 +-
 .../staging/usbip/userspace/libsrc/stub_driver.c   |   12 +-
 .../staging/usbip/userspace/libsrc/usbip_common.h  |    6 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   76 ++-
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   19 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |   11 +-
 drivers/staging/usbip/userspace/src/bind-driver.c  |  643 ----------------
 drivers/staging/usbip/userspace/src/usbip.c        |  813 ++++----------------
 drivers/staging/usbip/userspace/src/usbip.h        |   39 +
 drivers/staging/usbip/userspace/src/usbip_attach.c |  228 ++++++
 drivers/staging/usbip/userspace/src/usbip_bind.c   |  261 +++++++
 drivers/staging/usbip/userspace/src/usbip_detach.c |  103 +++
 drivers/staging/usbip/userspace/src/usbip_list.c   |  306 ++++++++
 .../staging/usbip/userspace/src/usbip_network.c    |   73 +-
 .../staging/usbip/userspace/src/usbip_network.h    |   37 +-
 drivers/staging/usbip/userspace/src/usbip_unbind.c |   95 +++
 drivers/staging/usbip/userspace/src/usbipd.c       |    8 +-
 drivers/staging/usbip/userspace/src/utils.c        |   60 ++-
 drivers/staging/usbip/userspace/src/utils.h        |    1 +
 19 files changed, 1347 insertions(+), 1448 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/src/bind-driver.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_attach.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_bind.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_detach.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_list.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_unbind.c

-- 
1.7.5.1

