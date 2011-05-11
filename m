Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1EKQGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:06:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44930 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab1EKQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZVAoJ+qK49mWohjgqfAx8c2GiEh+N7mTBN5HSbaNjMMsasctzNX8zA2BwUaJRhgntX
         wk6t0hiQ6+CUUW125axDAlzM9f0YiavKZfMSpuDU0Oo7gSq7XF/2nb19uDLbTxQvBnSJ
         I5J4hjHZERKplSnLUEKoYM8oFp0q0oYbuQFyc=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
Date: Wed, 11 May 2011 01:54:12 -0700
Message-Id: <cover.1305103212.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am interested in hearing your thoughts on the userspace interface?

Even as is, it definitely needs some work. For one thing I was thinking
of removing the debug flag from userspace. The userspace utilites are
not using it anyway, and it is not 100% working yet.

Thanks,
matt

matt mooney (12):
  staging: usbip: change debug configuration option
  staging: usbip: use single version for all modules
  staging: usbip: fix header includes
  staging: usbip: replace usbip_u{dbg,err,info} and printk with pr_
    equivalent
  staging: usbip: remove unnecessary lines and extra return statements
  staging: usbip: stub_main.c: code cleanup
  staging: usbip: stub_main.c: change __init/__exit prefix and use
    KMEM_CACHE
  staging: usbip: usbip_common.c: fix misspelled function name
  staging: usbip: edit Kconfig and rename CONFIG options
  staging: usbip: stub.h: reorganize
  staging: usbip: vhci.h: reorganize
  staging: usbip: usbip_common.h: reorganize and document request
    headers

 drivers/staging/Makefile             |    2 +-
 drivers/staging/usbip/Kconfig        |   52 +++---
 drivers/staging/usbip/Makefile       |   11 +-
 drivers/staging/usbip/stub.h         |   29 ++--
 drivers/staging/usbip/stub_dev.c     |   30 ++--
 drivers/staging/usbip/stub_main.c    |  225 ++++++++++++--------------
 drivers/staging/usbip/stub_rx.c      |   29 ++--
 drivers/staging/usbip/stub_tx.c      |   31 ++--
 drivers/staging/usbip/usbip_common.c |  262 ++++++++++++++----------------
 drivers/staging/usbip/usbip_common.h |  302 ++++++++++++++++------------------
 drivers/staging/usbip/usbip_event.c  |    4 +-
 drivers/staging/usbip/vhci.h         |   16 ++-
 drivers/staging/usbip/vhci_hcd.c     |  107 +++++-------
 drivers/staging/usbip/vhci_rx.c      |   37 ++---
 drivers/staging/usbip/vhci_sysfs.c   |   19 +-
 drivers/staging/usbip/vhci_tx.c      |   10 +-
 16 files changed, 541 insertions(+), 625 deletions(-)

-- 
1.7.5.1

