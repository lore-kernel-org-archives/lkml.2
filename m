Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1JAIoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 04:44:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55661 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1JAIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 04:44:14 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/3] staging: wlags49_h2: DBG cleanups
Date: Sat,  1 Oct 2011 09:43:47 +0100
Message-Id: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing some preliminary WPA patches, some issues with the DBG
machinery cropped up. This series just addresses those.

David Kilroy (3):
  staging: wlags49_h2: Use C99 __func__
  staging: wlags49_h2: Remove unused debug function
  staging: wlags49_h2: Remove bad debug message

 drivers/staging/wlags49_h2/debug.h     |   61 ++++++++++--------
 drivers/staging/wlags49_h2/wl_cs.c     |  114 --------------------------------
 drivers/staging/wlags49_h2/wl_netdev.c |    2 +-
 drivers/staging/wlags49_h2/wl_wext.c   |    1 -
 4 files changed, 35 insertions(+), 143 deletions(-)

-- 
1.7.4.1

