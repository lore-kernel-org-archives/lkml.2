Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1ISUJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:09:08 -0400
Received: from mail-wy0-f175.google.com ([74.125.82.175]:47330 "EHLO
	mail-wy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab1ISUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:09:04 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/3] staging: wlags49_h2: Improve WEXT support
Date: Mon, 19 Sep 2011 21:08:13 +0100
Message-Id: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are reports of issues using WPA with this driver. This series of
patches fixes a few obvious issues with the WEXT support in this
driver.

The changes have not recieved any testing. YMMV.

David Kilroy (3):
  staging: wlags49_h2: Remove old WIRELESS_EXT support
  staging: wlags49_h2: Support standard WEXT events
  staging: wlags49_h2: Declare support for WEXT 21

 drivers/staging/wlags49_h2/wl_internal.h |    7 --
 drivers/staging/wlags49_h2/wl_version.h  |    6 +-
 drivers/staging/wlags49_h2/wl_wext.c     |  152 ++++--------------------------
 drivers/staging/wlags49_h2/wl_wext.h     |    8 --
 4 files changed, 20 insertions(+), 153 deletions(-)

-- 
1.7.4.1

