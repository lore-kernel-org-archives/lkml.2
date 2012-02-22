Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2BVSci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:32:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59204 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754820Ab2BVScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:32:36 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19q/G5pCe1qSIbU11eWZVt9M2DkyShMh9Gdr0c1fz
	aZXGJzipf6X7qf
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 0/5] viafb misc patches
Date: Wed, 22 Feb 2012 18:53:04 +0000
Message-Id: <cover.1329936280.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is another patch series for viafb. 1 and 2 are fixes for 
previous patch series; 3 and 4 are fixes for our VX900 support; 
5 is a cleanup


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (5):
  viafb: another workaround for OLPCs weird wiring
  viafb: Fix bug in centering code
  viafb: select HW scaling on VX900 for IGA2
  viafb: fix IGA1 modesetting on VX900
  viafb: LCD bpp cleanup

 drivers/video/via/chip.h     |    1 -
 drivers/video/via/hw.c       |   22 +++++++---------------
 drivers/video/via/hw.h       |    2 +-
 drivers/video/via/lcd.c      |   21 ++++++++-------------
 drivers/video/via/viafbdev.c |    8 +++++---
 5 files changed, 21 insertions(+), 33 deletions(-)

-- 
1.7.9

