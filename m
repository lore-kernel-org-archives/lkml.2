Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0EDKqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:46:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22278 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0EDKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:46:47 -0400
X-SpamScore: 0
X-BigFish: VPS0(z5edIzab9bhzz1202hzz6ff19hz32i2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-01-7XN-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/7] oprofile: update file list in MAINTAINERS file
Date: Tue, 4 May 2010 12:44:47 +0200
Message-ID: <1272969893-29233-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File list now catches:

 $ xargs | eval ls -d $(cat) | sort -u
 arch/*/include/asm/oprofile*.h
 arch/*/oprofile/
 drivers/oprofile/
 include/linux/oprofile.h

 arch/alpha/oprofile/
 arch/arm/oprofile/
 arch/avr32/oprofile/
 arch/blackfin/oprofile/
 arch/ia64/oprofile/
 arch/m32r/oprofile/
 arch/microblaze/oprofile/
 arch/mips/oprofile/
 arch/mn10300/oprofile/
 arch/parisc/oprofile/
 arch/powerpc/include/asm/oprofile_impl.h
 arch/powerpc/oprofile/
 arch/s390/oprofile/
 arch/sh/oprofile/
 arch/sparc/oprofile/
 arch/x86/oprofile/
 drivers/oprofile/
 include/linux/oprofile.h

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a0e3c3a..31e8586 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4165,6 +4165,7 @@ OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
 S:	Maintained
+F:	arch/*/include/asm/oprofile*.h
 F:	arch/*/oprofile/
 F:	drivers/oprofile/
 F:	include/linux/oprofile.h
-- 
1.7.0.3


