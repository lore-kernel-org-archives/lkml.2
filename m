Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab1GOGVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:21:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59558 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab1GOGVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:21:51 -0400
Subject: [PATCH 14/16] SCSI: wd7000: remove Scsi_Cmnd
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Miroslav Zagorac <zaga@fly.cc.fer.hr>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 15 Jul 2011 02:20:35 -0400
Message-ID: <1310710835.3184.65.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/wd7000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..6127672 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1568,7 +1568,7 @@ static int wd7000_release(struct Scsi_Host *shost)
 /*
  *  I have absolutely NO idea how to do an abort with the WD7000...
  */
-static int wd7000_abort(Scsi_Cmnd * SCpnt)
+static int wd7000_abort(struct scsi_cmnd * SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-- 
1.7.4.1





