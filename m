Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2FMUO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:14:56 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1801 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab2FMUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:14:55 -0400
Message-ID: <1339618490.30984.178.camel@x61.thuisdomein>
Subject: [PATCH] ARM: davinci: remove dummy header files
From: Paul Bolle <pebolle@tiscali.nl>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 22:14:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2012 20:14:50.0282 (UTC) FILETIME=[2FB8E0A0:01CD49A1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These dummy headers are unused. Commit
6ea96e111e6a7f06ef62227bf64e8cd65bd705b3 ("ARM: davinci: add back dummy
header files") only added them as a temporary measure. They can be
removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 arch/arm/mach-davinci/include/mach/dm365.h  |    1 -
 arch/arm/mach-davinci/include/mach/dm646x.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm365.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm646x.h

diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
deleted file mode 100644
index b9bf3d6..0000000
--- a/arch/arm/mach-davinci/include/mach/dm365.h
+++ /dev/null
@@ -1 +0,0 @@
-/* empty, remove once unused */
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
deleted file mode 100644
index b9bf3d6..0000000
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ /dev/null
@@ -1 +0,0 @@
-/* empty, remove once unused */
-- 
1.7.7.6

