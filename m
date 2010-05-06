Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab0EFRh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759320Ab0EFRh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/13] drivers/scsi: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:14 +0200
Message-Id: <1273167377-14270-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/scsi/aic7xxx_old.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 93984c9..c0953be 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -9655,9 +9655,7 @@ aic7xxx_detect(struct scsi_host_template *template)
           found++;
 	  continue;
 skip_pci_controller:
-#ifdef CONFIG_PCI
 	  pci_release_regions(temp_p->pdev);
-#endif
 	  kfree(temp_p);
         }  /* Found an Adaptec PCI device. */
         else /* Well, we found one, but we couldn't get any memory */
-- 
1.6.6.1

