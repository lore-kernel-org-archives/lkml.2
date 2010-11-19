Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0KSWYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:24:04 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:59191 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab0KSV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:52 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 0/9] sisfb: remove cruft code
Date: Fri, 19 Nov 2010 23:58:42 +0200
Message-Id: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series deletes unused/unneeded code from sisfb, while not changing
the functionality.

Aaro Koskinen (9):
  sisfb: delete obsolete PCI ROM bug workaround
  sisfb: delete fallback code for pci_map_rom()
  sisfb: delete dead SIS_XORG_XF86 code
  sisfb: delete redudant #define SIS_LINUX_KERNEL
  sisfb: use CONFIG_FB_SIS_301/315 instead of SIS301/315H
  sisfb: remove InPort/OutPort wrappers
  sisfb: replace SiS_SetMemory with memset_io
  sisfb: move the CONFIG warning to sis_main.c
  sisfb: delete osdef.h

 drivers/video/sis/init.c       |  685 +++-------------------------------------
 drivers/video/sis/init.h       |   63 +----
 drivers/video/sis/init301.c    |  467 ++++++++-------------------
 drivers/video/sis/init301.h    |   43 +--
 drivers/video/sis/initextlfb.c |    7 +-
 drivers/video/sis/osdef.h      |  133 --------
 drivers/video/sis/sis.h        |    1 -
 drivers/video/sis/sis_main.c   |   30 +--
 drivers/video/sis/vgatypes.h   |   11 -
 drivers/video/sis/vstruct.h    |   12 -
 10 files changed, 209 insertions(+), 1243 deletions(-)
 delete mode 100644 drivers/video/sis/osdef.h

