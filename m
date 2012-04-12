Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635Ab2DLQMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:12:55 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:38897 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934403Ab2DLQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:12:54 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] dmaengine fixes for the -rc:s
Date: Thu, 12 Apr 2012 18:12:19 +0200
Message-ID: <1334247139-17316-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

These two fixes are critical for the ux500 to work on the v3.4-rc2
series. Enjoy!

Linus Walleij (2):
  dma/ste_dma40: explicitly include regulator consumer header
  dma/ste_dma40: fix erroneous comparison

 drivers/dma/ste_dma40.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.2

