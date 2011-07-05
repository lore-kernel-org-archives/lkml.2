Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1GEQpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:45:46 -0400
Received: from mail.perches.com ([173.55.12.10]:3532 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab1GEQmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:19 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 02/14] MAINTAINERS: Add STAGING - COMEDI
Date: Tue,  5 Jul 2011 09:42:02 -0700
Message-Id: <77c6a74ccb9525447a9856b379ad7a3e8495e790.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f0d683..6d8e58b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6074,6 +6074,12 @@ M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/asus_oled/
 
+STAGING - COMEDI
+M:	Ian Abbott <abbotti@mev.co.uk>
+M:	Mori Hess <fmhess@users.sourceforge.net>
+S:	Odd Fixes
+F:	drivers/staging/comedi/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.6.131.g99019

