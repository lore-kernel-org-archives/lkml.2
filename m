Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2LUI1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:27:52 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36352 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2LUI1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:27:48 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 21 Dec 2012 13:57:27 +0530
Message-ID: <CA+V-a8tNe1r3rzjR_jVHCYzEFQVaBbt0eRg602LJVgodkxQhiw@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] Davinci VPFE Media Controller capture driver for DM365
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for DaVinci VPFE driver for DM365.
The patches have gone through good amount of reviews, and
Acked by Laurent, Hans and Sakari and is agreed to be part of the staging.

Regards,
--Prabhakar


The following changes since commit 4bb891ebf60eb43ebd04e09bbcad24013067873f:

  [media] ivtv: ivtv-driver: Replace 'flush_work_sync()' (2012-12-20
15:22:30 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git vpfe_driver_staging

Manjunath Hadli (9):
      davinci: vpfe: add v4l2 capture driver with media interface
      davinci: vpfe: add v4l2 video driver support
      davinci: vpfe: dm365: add IPIPEIF driver based on media framework
      davinci: vpfe: dm365: add ISIF driver based on media framework
      davinci: vpfe: dm365: add IPIPE support for media controller driver
      davinci: vpfe: dm365: add IPIPE hardware layer support
      davinci: vpfe: dm365: resizer driver based on media framework
      davinci: vpfe: dm365: add build infrastructure for capture driver
      davinci: vpfe: Add documentation and TODO

 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/davinci_vpfe/Kconfig         |    9 +
 drivers/staging/media/davinci_vpfe/Makefile        |    3 +
 drivers/staging/media/davinci_vpfe/TODO            |   37 +
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |  154 ++
 .../staging/media/davinci_vpfe/davinci_vpfe_user.h | 1290 ++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 1863 +++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.h   |  179 ++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    | 1048 ++++++++++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |  559 ++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1071 ++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h |  233 +++
 .../media/davinci_vpfe/dm365_ipipeif_user.h        |   93 +
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2104 ++++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_isif.h    |  203 ++
 .../staging/media/davinci_vpfe/dm365_isif_regs.h   |  294 +++
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 1999 +++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |  244 +++
 drivers/staging/media/davinci_vpfe/vpfe.h          |   86 +
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  740 +++++++
 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |   97 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 1620 +++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  155 ++
 24 files changed, 14084 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/davinci_vpfe/Kconfig
 create mode 100644 drivers/staging/media/davinci_vpfe/Makefile
 create mode 100644 drivers/staging/media/davinci_vpfe/TODO
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.h
