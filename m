Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1JQSdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:33:44 -0400
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1131 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752650Ab1JQSdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:33:42 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10856
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        alsa-devel@alsa-project.org, drivers@analog.com,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MAINTAINERS: Add maintainer for Analog Devices sound CODECs
Date: Mon, 17 Oct 2011 20:33:05 +0200
Message-Id: <1318876385-26902-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAINTAINERS  entry for the ADI sound CODEC drivers currently only lists the
ADI devices-drivers-devel mailing-list. Add myself as additional contact, since
I'm the person at ADI who is currently doing most of the work on these drivers.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b4ccdd..b2dabb7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -530,6 +530,7 @@ S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
 ANALOG DEVICES INC ASOC CODEC DRIVERS
+M:	Lars-Peter Clausen <lars@metafoo.de>
 L:	device-drivers-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
-- 
1.7.2.5

