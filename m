Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1DXUhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 16:37:17 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:59947 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757745Ab1DXUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 16:37:13 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB489B8.70407@verizon.net>
Date: Sun, 24 Apr 2011 16:36:08 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <ysato@users.sourceforge.jp>
Subject: [PATCH 1/2] arch: h8300: update Kconfig to point to new serial drivers
 location
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the h8300 Kconfig to point to drivers/tty/serial
instead of drivers/serial.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/h8300/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index e20322f..e312085 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -203,7 +203,7 @@ config UNIX98_PTYS

 source "drivers/char/pcmcia/Kconfig"

-source "drivers/serial/Kconfig"
+source "drivers/tty/serial/Kconfig"

 source "drivers/i2c/Kconfig"

-- 
1.7.5.rc1


