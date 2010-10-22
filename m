Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0JVHFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:05:51 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:38530 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JVHFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:05:50 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 14/30] staging/vme_user: use an unsigned int for counting the number of kparams
Date: Fri, 22 Oct 2010 02:36:36 -0400
Message-Id: <1287729412-24356-15-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

unsigned int is what struct kparam_array internally uses.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 31a74e2..e7669a4 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -44,7 +44,7 @@ static DEFINE_MUTEX(vme_user_mutex);
 static char driver_name[] = "vme_user";
 
 static int bus[USER_BUS_MAX];
-static int bus_num;
+static unsigned int bus_num;
 
 /* Currently Documentation/devices.txt defines the following for VME:
  *
-- 
1.7.1

