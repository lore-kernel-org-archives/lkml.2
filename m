Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2FUDlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:41:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47742 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2FUDlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:41:22 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm-cc@laptop.org, ngupta@vflare.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/2] ZRAM Cleanup
Date: Thu, 21 Jun 2012 00:32:43 -0300
Message-Id: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches cleans a little the zram driver.

I hope you enjoy :)

Marcos Paulo de Souza (2):
  staging: zram: Remove dead code
  staging: zram: Remove useless struct zobj_header

 drivers/staging/zram/zram_drv.c |   18 +++---------------
 drivers/staging/zram/zram_drv.h |   12 ------------
 2 files changed, 3 insertions(+), 27 deletions(-)

-- 
1.7.10.2

