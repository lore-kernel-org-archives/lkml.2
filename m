Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1GEQpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:45:08 -0400
Received: from mail.perches.com ([173.55.12.10]:3536 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab1GEQmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:20 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 03/14] MAINTAINERS: Add STAGING - CRYSTAL HD VIDEO DECODER
Date: Tue,  5 Jul 2011 09:42:03 -0700
Message-Id: <0c25eef2bdb7e9946611e8e8ea6f7f1f6be993be.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d8e58b..e42923b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6080,6 +6080,14 @@ M:	Mori Hess <fmhess@users.sourceforge.net>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
+STAGING - CRYSTAL HD VIDEO DECODER
+M:	Naren Sankar <nsankar@broadcom.com>
+M:	Jarod Wilson <jarod@wilsonet.com>
+M:	Scott Davilla <davilla@4pi.com>
+M:	Manu Abraham <abraham.manu@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/crystalhd/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019

