Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1JNWiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:38:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34759 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1JNWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:38:08 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: [PATCH 1/2] xen: Fix XEN_MAX_DOMAIN_MEMORY to be selectable
Date: Fri, 14 Oct 2011 15:36:50 -0700
Message-Id: <1318631811-21559-2-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090204.4E98B9CD.0039,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'int' parameter also needs a description. Otherwise
it cannot be selected by the user.

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 7cbcbd1..0b452c7 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -28,7 +28,7 @@ config XEN_PVHVM
 	depends on XEN && PCI && X86_LOCAL_APIC
 
 config XEN_MAX_DOMAIN_MEMORY
-       int
+       int "Maximum allowed size of a domain in gigabytes"
        default 128
        depends on XEN
        help
-- 
1.7.4.1

