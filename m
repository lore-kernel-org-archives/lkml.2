Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab0LTVxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:53:31 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48479 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab0LTVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:03 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 00/13] Further sisfb cleanups
Date: Mon, 20 Dec 2010 23:50:09 +0200
Message-Id: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some further cleanups for sisfb. The most visible change is that
sis_main.c is changed to use the same register I/O functions that other
files are using.

Aaro Koskinen (13):
  sisfb: eliminate unused variable compiler warning
  sisfb: delete HAVE_CONFIG_H checks
  sisfb: remove duplicate function declarations
  sisfb: change register I/O functions to use fixed size types
  sisfb: replace inSISREG with SiS_GetRegByte
  sisfb: replace outSISREG with SiS_SetRegByte
  sisfb: replace inSISIDXREG with SiS_GetReg
  sisfb: replace outSISIDXREG with SiS_SetReg
  sisfb: replace orSISIDXREG with SiS_SetRegOR
  sisfb: replace andSISIDXREG with SiS_SetRegAND
  sisfb: replace setSISIDXREG with SiS_SetRegANDOR
  sisfb: delete unused register I/O macros
  sisfb: eliminate compiler warnings

 drivers/video/sis/init.c     |   46 +-
 drivers/video/sis/init.h     |   13 -
 drivers/video/sis/init301.c  |    8 +-
 drivers/video/sis/init301.h  |   11 -
 drivers/video/sis/sis.h      |   65 +--
 drivers/video/sis/sis_main.c | 1196 +++++++++++++++++++++---------------------
 6 files changed, 635 insertions(+), 704 deletions(-)

