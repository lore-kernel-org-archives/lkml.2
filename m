Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0CWRPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:15:02 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:53734 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab0CWRPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:15:01 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module parameter
Date: Tue, 23 Mar 2010 18:14:59 +0100
Message-ID: <87634n0xkc.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..ac08397 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -69,8 +69,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
-		"Enables FDMI registratons "
-		"Default is 0 - no FDMI. 1 - perfom FDMI.");
+		"Enables FDMI registrations. "
+		"0 - no FDMI. Default is 1 - perform FDMI.");
 
 #define MAX_Q_DEPTH    32
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
-- 
1.5.6.5

