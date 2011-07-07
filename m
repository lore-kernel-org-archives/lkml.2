Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1GGHdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:33:18 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:38636 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab1GGHdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:33:15 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] staging: usbip: rebased userspace patches
Date: Thu,  7 Jul 2011 00:31:49 -0700
Message-Id: <cover.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg,

Here are the patches that didn't apply rebased onto your staging-next
branch. There were only three, but I have included a few other small
patches.

Thanks,
matt

matt mooney (7):
  staging: usbip: userspace: usbipd: major cleanup of daemon
  staging: usbip: userspace: add new prefix for usbip network code
  staging: usbip: userspace: fix header installation bug
  staging: usbip: userspace: usbip_list.c: modify exportable device
    output
  staging: usbip: userspace: usbip: modify `list' help message
  staging: usbip: userspace: README: update example output
  staging: usbip: userspace: usbip-utils 1.1.1

 drivers/staging/usbip/userspace/Makefile.am        |    2 +-
 drivers/staging/usbip/userspace/README             |   53 +-
 drivers/staging/usbip/userspace/configure.ac       |    4 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    6 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |    6 +-
 drivers/staging/usbip/userspace/src/usbip.c        |    2 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |   10 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |   36 +-
 .../staging/usbip/userspace/src/usbip_network.c    |   56 +-
 .../staging/usbip/userspace/src/usbip_network.h    |   39 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |  695 ++++++++++----------
 11 files changed, 456 insertions(+), 453 deletions(-)

-- 
1.7.6

