Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0GWBNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:13:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45422 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0GWBMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:12:50 -0400
From: Armando Uribe <x0095078@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Armando Uribe <x0095078@ti.com>
Subject: [PATCH 0/9] staging: tidspbridge: Code Clean Up related to macros
Date: Thu, 22 Jul 2010 20:25:25 -0500
Message-Id: <1279848334-4043-1-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches are intended do a code clean up 
related to macros, i.e. use of static inline, remove unused macros, etc.

Armando Uribe (9):
  staging: tidspbridge: Remove Redundant wrappers
  staging: tidspbridge: Remove redundant macros in io_sm.c
  staging: tidspbridge: Change macros to static inline functions in
    io_sm
  staging: tidspbridge: Change macros to static inline functions used
    in cload
  staging: tidspbridge: Remove redundant macro from cod.c
  staging: tidspbridge: Remove unused magic number
  staging: tidspbridge: Remove macros used as cast
  staging: tidspbridge: Change macros to static inline functions
  staging: tidspbridge: Remove unused macros

 drivers/staging/tidspbridge/core/chnl_sm.c         |    2 +-
 drivers/staging/tidspbridge/core/io_sm.c           |  197 ++++++--------------
 drivers/staging/tidspbridge/dynload/cload.c        |   35 ++--
 .../staging/tidspbridge/dynload/dload_internal.h   |    4 -
 drivers/staging/tidspbridge/dynload/doff.h         |   38 +++--
 drivers/staging/tidspbridge/dynload/getsection.c   |   17 +--
 drivers/staging/tidspbridge/dynload/reloc.c        |    2 +-
 .../tidspbridge/dynload/reloc_table_c6000.c        |    2 +-
 drivers/staging/tidspbridge/dynload/tramp.c        |    2 +-
 .../tidspbridge/dynload/tramp_table_c6000.c        |    2 +-
 .../tidspbridge/include/dspbridge/chnldefs.h       |    1 -
 .../tidspbridge/include/dspbridge/chnlpriv.h       |    3 -
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |   43 +----
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   13 --
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |   14 --
 drivers/staging/tidspbridge/pmgr/cod.c             |   34 ++---
 drivers/staging/tidspbridge/pmgr/dbll.c            |    5 +-
 drivers/staging/tidspbridge/rmgr/disp.c            |    2 -
 drivers/staging/tidspbridge/rmgr/nldr.c            |   33 +---
 drivers/staging/tidspbridge/rmgr/proc.c            |    4 +-
 20 files changed, 140 insertions(+), 313 deletions(-)

