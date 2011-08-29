Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1H2RoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:44:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1H2RoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:06 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/6] MAINAINERS: Add details for drivers/staging/et131x
Date: Mon, 29 Aug 2011 18:42:37 +0100
Message-Id: <1314639761-4947-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding myself as a maintainer for this driver, as I appear to have been the only interested party for some time.
Not sure if Olaf Hartman is still interested? So will leave it up to him to add his name to the list.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a8cc60..4f00a54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6172,6 +6172,11 @@ M:	David Rowe <david@rowetel.com>
 S:	Odd Fixes
 F:	drivers/staging/echo/
 
+STAGING - ET131X NETWORK DRIVER
+M:	Mark Einon <mark.einon@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/et131x/
+
 STAGING - FLARION FT1000 DRIVERS
 M:	Marek Belisko <marek.belisko@gmail.com>
 S:	Odd Fixes
-- 
1.7.6

