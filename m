Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1FMMUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:20:32 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41831 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab1FMMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:41 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option description
Date: Mon, 13 Jun 2011 16:18:29 +0400
Message-Id: <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both bars=0 and bars=1 were described as meaning to display bars on
signal lost. Actually bars=1 means "display bars", but bars=0 means
display raw source as is (usually black screen).

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index 16b8264..cd55eea 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -60,7 +60,7 @@ Three module parameters are defined:
 
 debug      the easycap module is configured at diagnostic level n (0 to 9)
 gain       audio gain level n (0 to 31, default is 16)
-bars       0 =>  testcard bars when incoming video signal is lost
+bars       0 =>  no testcard bars when incoming video signal is lost
            1 =>  testcard bars when incoming video signal is lost (default)
 
 
-- 
1.7.6.rc1

