Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2B0JXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:23:50 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53555
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2B0JXs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:23:48 -0500
X-SpamScore: -7
X-BigFish: VPS-7(zcb8kz542M1432Nzz1202hzz8275bh8275dhz2ei2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Petr Uzel <petr.uzel@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Ravi Anand <ravi.anand@qlogic.com>,
        Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <trivial@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Date: Mon, 27 Feb 2012 01:23:40 -0800
Subject: Re: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces
 to error messages
Thread-Topic: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces
 to error messages
Thread-Index: Acz1MX+W1Cu7ot1AQamr85TrzEWuPQ==
Message-ID: <CB714933.CF07%vikas.chaudhary@qlogic.com>
In-Reply-To: <1330097579-25679-1-git-send-email-petr.uzel@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.13.0.110805
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Petr Uzel <petr.uzel@suse.cz>
Date: Fri, 24 Feb 2012 07:32:59 -0800
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary
<vikas.chaudhary@qlogic.com>, Dept-Eng iSCSI Driver
<Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, Jiri Kosina <trivial@kernel.org>, scsi
<linux-scsi@vger.kernel.org>
Subject: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces to
error messages

>
>Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
>---
> drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index ce6d3b7..edf5034 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -3382,7 +3382,7 @@ static int get_fw_boot_info(struct scsi_qla_host
>*ha, uint16_t ddb_index[])
>               if (qla4xxx_get_flash(ha, buf_dma, addr,
>                                     13 * sizeof(uint8_t)) != QLA_SUCCESS) {
>                       DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: Get Flash"
>-                                        "failed\n", ha->host_no, __func__));
>+                                        " failed\n", ha->host_no, __func__));
>                       ret = QLA_ERROR;
>                       goto exit_boot_info_free;
>               }
>@@ -3620,7 +3620,7 @@ static int qla4xxx_setup_boot_info(struct
>scsi_qla_host *ha)
>
>       if (ql4xdisablesysfsboot) {
>               ql4_printk(KERN_INFO, ha,
>-                         "%s: syfsboot disabled - driver will trigger login"
>+                         "%s: syfsboot disabled - driver will trigger login "
>                          "and publish session for discovery .\n", __func__);
>               return QLA_SUCCESS;
>       }
>--
>1.7.7

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

