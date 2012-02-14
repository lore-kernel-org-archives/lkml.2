Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2BNFvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:51:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48461 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466Ab2BNFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:51:13 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX190LENNulF0ANzSth/fIxhJvMnZFCVawrSZiFbQcb
	0a1g340RBrLrkA
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 0/4] implement viafb SAMM mode
Date: Tue, 14 Feb 2012 06:12:01 +0000
Message-Id: <cover.1329194838.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this patch series implements viafb single adapter multiple monitor 
mode in a useful way. It allows showing the same image on 2 devices 
with different video modes by centering the smaller image.
It is useful for presentation or similar tasks, whenever dual fb is 
not desired. I have now used it for quite some time.


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (4):
  viafb: set correct polarity for second adapter
  viafb: fill xres and yres
  viafb: make single framebuffer multiple adapter mode work
  viafb: make SAMM to also work on LCD

 drivers/video/via/chip.h |    2 -
 drivers/video/via/dvi.c  |    5 ++-
 drivers/video/via/dvi.h  |    3 +-
 drivers/video/via/hw.c   |   85 +++++++++++++++++++++++----------------------
 drivers/video/via/hw.h   |    3 +-
 drivers/video/via/lcd.c  |   18 +++++-----
 drivers/video/via/lcd.h  |    3 +-
 7 files changed, 61 insertions(+), 58 deletions(-)

-- 
1.7.9

