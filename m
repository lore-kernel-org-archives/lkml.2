Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0EFRip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab0EFRiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/13] drivers/ata: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:17 +0200
Message-Id: <1273167377-14270-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/ata/ahci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8b502f4..5326af2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -3179,7 +3179,6 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 #ifdef CONFIG_ATA_ACPI
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
-#ifdef CONFIG_ATA_ACPI
 	static const struct dmi_system_id sysids[] = {
 		/*
 		 * Aspire 3810T issues a bunch of SATA enable commands
@@ -3220,7 +3219,6 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 			ata_for_each_dev(dev, link, ALL)
 				dev->gtf_filter |= filter;
 	}
-#endif
 }
 #else
 static inline void ahci_gtf_filter_workaround(struct ata_host *host)
-- 
1.6.6.1

