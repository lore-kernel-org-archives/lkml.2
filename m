Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2HUTl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:41:29 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:49713 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2HUTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:41:25 -0400
From: Jaeden Amero <jaeden.amero@ni.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jaeden Amero <jaeden.amero@ni.com>
Subject: [PATCH RESEND] compat_ioctl: Add RS-485 IOCTLs to the list
Date: Tue, 21 Aug 2012 14:41:09 -0500
Message-Id: <1345578069-13372-1-git-send-email-jaeden.amero@ni.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1342625097-20534-1-git-send-email-jaeden.amero@ni.com>
References: <1342625097-20534-1-git-send-email-jaeden.amero@ni.com>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.2FP3|July 10, 2011) at
 08/21/2012 02:41:24 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.2FP3|July 10, 2011) at
 08/21/2012 02:41:24 PM,
	Serialize complete at 08/21/2012 02:41:25 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.2FP3|July 10, 2011) at
 08/21/2012 02:41:25 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-21_05:2012-08-21,2012-08-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RS-485 TIOCSRS485 and TIOCGRS485 ioctls are 32-bit compatible, so
in order to call them on 64-bit systems from 32-bit user mode, we add
them to the ioctl pointer list as compatible ioctls.

Signed-off-by: Jaeden Amero <jaeden.amero@ni.com>
---
 fs/compat_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index debdfe0fc809edfd01ac4a72a0eaf2753efc993d..85dfebfe6820856dc3154dfd178acb6fca63bbe9 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -866,6 +866,8 @@ COMPATIBLE_IOCTL(TIOCGPTN)
 COMPATIBLE_IOCTL(TIOCSPTLCK)
 COMPATIBLE_IOCTL(TIOCSERGETLSR)
 COMPATIBLE_IOCTL(TIOCSIG)
+COMPATIBLE_IOCTL(TIOCSRS485)
+COMPATIBLE_IOCTL(TIOCGRS485)
 #ifdef TCGETS2
 COMPATIBLE_IOCTL(TCGETS2)
 COMPATIBLE_IOCTL(TCSETS2)
-- 
1.7.12

