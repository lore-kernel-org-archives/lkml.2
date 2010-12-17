Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0LQBEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:04:40 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:56486 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab0LQBEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:04:39 -0500
From: Armando Uribe <x0095078@ti.com>
To: <omar.ramirez@ti.com>
Cc: <x0095078@ti.com>, <ohad@wizery.com>, <felipe.contreras@gmail.com>,
        <rene.sapiens@ti.com>, <nm@ti.com>, <ernesto@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 0/5] staging:tidspbridge - Audit headers file
Date: Thu, 16 Dec 2010 19:18:28 -0600
Message-Id: <1292548713-27061-1-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches performs a code clean up
derived from a header files audit. Removes unused macros,
constants, functions, structs, struct members, typedefs and
its dependencies.

Armando Uribe (5):
  staging:tidspbridge - Remove unused defined constants
  staging:tidspbridge - Remove unused functions
  staging:tidspbridge - Remove unused structs.
  staging:tidspbridge - Remove unused typedefs
  staging:tidspbridge -  Remove trivial header files

 drivers/staging/tidspbridge/core/io_sm.c           |    4 -
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 -
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 +-
 .../tidspbridge/include/dspbridge/brddefs.h        |    2 -
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   19 ---
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   21 ---
 .../tidspbridge/include/dspbridge/chnldefs.h       |    3 -
 .../tidspbridge/include/dspbridge/chnlpriv.h       |   13 --
 .../staging/tidspbridge/include/dspbridge/cod.h    |   13 +--
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |   26 ----
 .../tidspbridge/include/dspbridge/dbldefs.h        |  141 -------------------
 .../staging/tidspbridge/include/dspbridge/dbll.h   |    6 -
 .../tidspbridge/include/dspbridge/dblldefs.h       |   65 ---------
 .../tidspbridge/include/dspbridge/dehdefs.h        |   32 -----
 .../staging/tidspbridge/include/dspbridge/dev.h    |   59 +--------
 .../staging/tidspbridge/include/dspbridge/disp.h   |   15 ++-
 .../tidspbridge/include/dspbridge/dispdefs.h       |   35 -----
 .../staging/tidspbridge/include/dspbridge/drv.h    |   31 +----
 .../tidspbridge/include/dspbridge/drvdefs.h        |   25 ----
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    8 -
 .../tidspbridge/include/dspbridge/dspdefs.h        |   10 +-
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |    2 -
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    4 +-
 .../tidspbridge/include/dspbridge/dspioctl.h       |    5 -
 .../tidspbridge/include/dspbridge/dynamic_loader.h |    2 -
 .../tidspbridge/include/dspbridge/host_os.h        |    9 --
 drivers/staging/tidspbridge/include/dspbridge/io.h |   29 ++---
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |  143 +-------------------
 .../staging/tidspbridge/include/dspbridge/iodefs.h |   36 -----
 .../staging/tidspbridge/include/dspbridge/ldr.h    |   29 ----
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |   40 ------
 .../staging/tidspbridge/include/dspbridge/node.h   |   20 +---
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 +-
 .../staging/tidspbridge/include/dspbridge/pwr_sh.h |   33 -----
 .../include/dspbridge/resourcecleanup.h            |   11 --
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |    9 --
 .../staging/tidspbridge/include/dspbridge/strm.h   |   62 ---------
 .../tidspbridge/include/dspbridge/strmdefs.h       |    2 -
 drivers/staging/tidspbridge/pmgr/cod.c             |   14 +--
 drivers/staging/tidspbridge/pmgr/dbll.c            |   41 ------
 drivers/staging/tidspbridge/pmgr/dev.c             |   10 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    1 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    1 -
 drivers/staging/tidspbridge/rmgr/nldr.c            |    3 -
 drivers/staging/tidspbridge/rmgr/node.c            |    1 -
 46 files changed, 55 insertions(+), 996 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dehdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dispdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/drvdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/iodefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/ldr.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr_sh.h

