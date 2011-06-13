Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1FMMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:19:36 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41739 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1FMMTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:35 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 0/5] staging/easycap cleanups + fix
Date: Mon, 13 Jun 2011 16:18:27 +0400
Message-Id: <cover.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello up there,

Recently I've bought Mobiledata's easycap, and while trying to make it work
under Linux, and studying the driver, have found some places to clean up and 1
bug related to bytesperline calculation.


Please apply and thanks,
Kirill


Kirill Smelkov (5):
  staging/easycap: Kill leftover build options in readme
  staging/easycap: Fix thinko in "bars" module option description
  staging/easycap: There is no need to support V4L1 ioctls
  staging/easycap: PAGE_SIZE is always defined
  staging/easycap: Fix bytesperline calculation

 drivers/staging/easycap/README             |   26 +-------------------------
 drivers/staging/easycap/easycap.h          |    4 ----
 drivers/staging/easycap/easycap_settings.c |    2 +-
 3 files changed, 2 insertions(+), 30 deletions(-)

-- 
1.7.6.rc1

