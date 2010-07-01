Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0GAT2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:28:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37484 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0GAT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XUXC1Xf3w6rtIDUBMdZDyRlh36cZpmsXwYT5V1MEvy9Ps3x7zsHf8ikp4poxCS2it3
         ZZtACE3otND9W4406TNdoHVit2CFJOUGZHLiU++sBe3O2rOg4bNR8N/12SzlTlsUy+6P
         Y/YjKDrn7fot2X52oSVfN2zmEVpcVWCA1woAI=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 13:28:40 -0600
Message-ID: <AANLkTimxEWtrUPyzK1jfYpQbowwXiBGNmQUpMBOj513o@mail.gmail.com>
Subject: 2.6.34 "make distclean" does not "make distclean"
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make distclean" leaves the following files, including a binary file
in the build tree without deleting them which results in this
stuff ending up in patches that has to be removed manually each time I
scrub a tree and cut patches against.

diff -Naur linux-2.6.34/arch/x86/tools/test_get_len
linux-2.6.34-work/arch/x86/tools/test_get_len
--- linux-2.6.34/arch/x86/tools/test_get_len	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.34-work/arch/x86/tools/test_get_len	2010-06-30
22:36:40.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/r100_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/r100_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/r100_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/r100_reg_safe.h	2010-06-30
22:33:19.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/r200_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/r200_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/r200_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/r200_reg_safe.h	2010-06-30
22:33:19.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/r300_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/r300_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/r300_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/r300_reg_safe.h	2010-06-30
22:33:23.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/r420_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/r420_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/r420_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/r420_reg_safe.h	2010-06-30
22:33:19.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/r600_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/r600_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/r600_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/r600_reg_safe.h	2010-06-30
22:33:20.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/rn50_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/rn50_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/rn50_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/rn50_reg_safe.h	2010-06-30
22:33:20.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/rs600_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/rs600_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/rs600_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/rs600_reg_safe.h	2010-06-30
22:33:23.000000000 -0600
diff -Naur linux-2.6.34/drivers/gpu/drm/radeon/rv515_reg_safe.h
linux-2.6.34-work/drivers/gpu/drm/radeon/rv515_reg_safe.h
--- linux-2.6.34/drivers/gpu/drm/radeon/rv515_reg_safe.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/drivers/gpu/drm/radeon/rv515_reg_safe.h	2010-06-30
22:33:23.000000000 -0600
diff -Naur linux-2.6.34/security/selinux/av_permissions.h
linux-2.6.34-work/security/selinux/av_permissions.h
--- linux-2.6.34/security/selinux/av_permissions.h	1969-12-31
17:00:00.000000000 -0700
+++ linux-2.6.34-work/security/selinux/av_permissions.h	2010-06-30
22:35:28.000000000 -0600
