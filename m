Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab0FEXdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:33:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0FEXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=me+armjgdTN3lLq43A0dL8iFgFuOscWbuVzM3K2ePRaSV4XFz4c1qz+IBvdVwx8e91
         dK6NUWohv5bM/EZxYaavCX+Z6f1Bo1B+sXsgFwulkNcxAbfQAhmoQEGhl72Z+2n+6ZeG
         pktY3zFezyze22S6oKf9p9Ir4bfh1BSh2jGcU=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 0/6] [STAGING] More xgifb cleanup
Date: Sun,  6 Jun 2010 01:33:10 +0200
Message-Id: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaud,

a few more patches for cleaning up the xgifb driver, please apply.

Riccardo Magliocchetti (6):
  More ifdefery cleanup.
  kill osdef.h
  Kill empty function NewDelaySeconds().
  Kill unused header
  Kill udelay wrapper
  Use standard types instead of typedefs.

 drivers/staging/xgifb/XGI.h         |   10 -
 drivers/staging/xgifb/XGI_main.h    |   38 +-
 drivers/staging/xgifb/XGI_main_26.c |   34 +-
 drivers/staging/xgifb/osdef.h       |   34 --
 drivers/staging/xgifb/vb_ext.c      |  122 ++--
 drivers/staging/xgifb/vb_ext.h      |   12 +-
 drivers/staging/xgifb/vb_init.c     |  434 ++++++++--------
 drivers/staging/xgifb/vb_init.h     |    2 +-
 drivers/staging/xgifb/vb_setmode.c  | 1032 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_setmode.h  |   38 +-
 drivers/staging/xgifb/vb_struct.h   |  609 ++++++++++-----------
 drivers/staging/xgifb/vb_table.h    |  236 ++++----
 drivers/staging/xgifb/vb_util.c     |  105 ++---
 drivers/staging/xgifb/vb_util.h     |   21 +-
 drivers/staging/xgifb/vgatypes.h    |  122 +----
 15 files changed, 1351 insertions(+), 1498 deletions(-)
 delete mode 100644 drivers/staging/xgifb/XGI.h
 delete mode 100644 drivers/staging/xgifb/osdef.h

