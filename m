Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0LMVm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:42:27 -0500
Received: from mail.perches.com ([173.55.12.10]:2565 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab0LMVm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:42:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 0/5] trivia: Use vsprintf extension %pR
Date: Mon, 13 Dec 2010 13:42:17 -0800
Message-Id: <cover.1292276119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (5):
  ste_dma40.c: Use vsprintf extension %pR for struct resource
  lba_pci.c: Use vsprintf extension %pR for struct resource
  samsung.c: Use vsprintf extension %pR for struct resource
  mx3fb.c: Use vsprintf extension %pR for struct resource
  ml403-ac97cr.c: Use vsprintf extension %pR for struct resource

 drivers/dma/ste_dma40.c      |    5 ++---
 drivers/parisc/lba_pci.c     |   13 +++++--------
 drivers/serial/samsung.c     |    2 +-
 drivers/video/mx3fb.c        |    3 +--
 sound/drivers/ml403-ac97cr.c |    4 ++--
 5 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.7.3.3.398.g0b0cd.dirty

