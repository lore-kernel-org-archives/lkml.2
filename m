Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1GJTRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 15:17:10 -0400
Received: from nm5-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.232]:48688 "HELO
	nm5-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756562Ab1GJTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 15:17:04 -0400
X-Yahoo-Newman-Id: 275312.71745.bm@smtp144.mail.ukl.yahoo.com
X-Yahoo-SMTP: jJZJ2V.swBDUsw.4BFRh6Rcl_N0lOoI1XeCD
X-YMail-OSG: VW6MMj0VM1mj4miVSotun828OUdZaaudZDjLy4ifctHqIMy
 43WiILl8Z5guaCeBR7k4WpPs72o91ueM3WQ.ZS2aENQSW51Wl26ZCNN2U.qX
 qsKpw2Ss2PW8JrIkE4xo5whZuRwv5YA4vlFLpZEQSfUkD_Tn0O9e1XEPDTsX
 HxLwE_1Q_6o679IiDsQBrlrL46v6LPA6poT7appxDjA_Fb.wk1iBKxEyKsdh
 JX5xXu7e48XfutiaBPKTT_HjAqPa8cmt5fTrbJ3xe8mDqyH8lfz6QIG0qXSz
 jSEnX8UVe6zI0VzrtYXF5tEOU.99yb3.KBX9dTnOvP4qcL3B86zlCWQ--
X-Yahoo-Newman-Property: ymail-3
From: markpearson_de@yahoo.de
To: greg@kroah.com
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: [PATCH 2/2] Staging: comedi: Fixed coding style issues.
Date: Sun, 10 Jul 2011 21:16:38 +0200
Message-Id: <1310325398-30449-2-git-send-email-markpearson_de@yahoo.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310325398-30449-1-git-send-email-markpearson_de@yahoo.de>
References: <1310325398-30449-1-git-send-email-markpearson_de@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Pearson <markpearson_de@yahoo.de>

comedi_fops.c : A forward decleration was declared as extern although it
                is a function private to this file. Changed the
                decleration to static.

Signed-off-by: Mark Pearson <markpearson_de@yahoo.de>
---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e7e72b8..88d7a0a 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -101,7 +101,7 @@ static int do_insn_ioctl(struct comedi_device *dev,
 static int do_poll_ioctl(struct comedi_device *dev, unsigned int subd,
 			 void *file);
 
-extern void do_become_nonbusy(struct comedi_device *dev,
+static void do_become_nonbusy(struct comedi_device *dev,
 			      struct comedi_subdevice *s);
 static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
-- 
1.7.0.4

