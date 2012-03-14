Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2CNEVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:21:40 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55090 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab2CNEVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:21:38 -0400
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: Sathisha Nanjappa <sathisha.nanjappa@hp.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jejb@kernel.org>
Date: Wed, 14 Mar 2012 09:51:30 +0530
Subject: RE: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Topic: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Index: Ac0BS6ijvEs0vtv3TNuXAygqWnaqJgATicpQ
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E731D0E@inbmail02.lsi.com>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
In-Reply-To: <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sathisha Nanjappa
Sent: Wednesday, March 14, 2012 12:29 AM
To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Sathisha Nanjappa
Subject: [PATCH] mpt2sas: Corrected the constant in comparison to a hexadecimal.

    Bugzilla 42142 - mpt2sas: Number specified in wrong base
    https://bugzilla.kernel.org/show_bug.cgi?id=42142

Signed-off-by: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..f9a1244 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -657,7 +657,7 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
 		return;
 
 	/* eat the loginfos associated with task aborts */
-	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
+	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
 		return;
 
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
