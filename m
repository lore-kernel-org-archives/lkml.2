Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1B1Qsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:48:52 -0500
Received: from kroah.org ([198.145.64.141]:48004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab1B1QhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.082989732@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>,
        maximilian attems <max@stro.at>
Subject: [24/68] [SCSI] scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 22963a37b3437a25812cc856afa5a84ad4a3f541 upstream.

Adds IBM Power Virtual SCSI ALUA devices to the ALUA device handler.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -702,6 +702,7 @@ static const struct scsi_dh_devlist alua
 	{"Pillar", "Axiom" },
 	{"Intel", "Multi-Flex"},
 	{"NETAPP", "LUN"},
+	{"AIX", "NVDISK"},
 	{NULL, NULL}
 };
 


