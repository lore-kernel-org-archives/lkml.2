Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0LIQlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35378 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0LIQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d4E6WW0mLT7q1ORFHPW4sEHp7yqZ4KzwjjBssEO6Tc/qYR/u2o1nRC9vIq1+vTnENX
         gLdzfjt27AMZ5EnXKQVtlG0LJBTQ26hB7nyoZSuy16uEkPVq5Bj2ByZ96gOZfVtdqALp
         A7ybo0//UjUuB9LQI7BBdtc0oecYPb6g/jc20=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] Staging: sm7xx: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:25 +0900
Message-Id: <1291912830-13151-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/sm7xx/smtcfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 24f47d6388f4..f4b163f7338a 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -996,7 +996,7 @@ failed_free:
 
 
 /* Jason (08/11/2009) PCI_DRV wrapper essential structs */
-static const struct pci_device_id smtcfb_pci_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{0x126f, 0x710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x720, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-- 
1.7.3.3.400.g93cef

