Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1FTKqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:46:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64821 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1FTKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:46:33 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
Cc: linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 0/2] video: Make omap2 support conditional
Date: Mon, 20 Jun 2011 16:15:59 +0530
Message-Id: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently drivers/video/omap2 is built by default with every configuration
of the kernel. Current patchset makes the omap2 video support conditional 
on appropriate config option. 

[Patch 2/2] was first generated, but that resulted in a build error. 
[Patch 1/2] was created to fix that build error.

These patches have only been tested for build consistency and have not been
tested on any related hardware.

Tushar Behera (2):
  config: omap2+: force fb and dss support as built-in
  video: omap2: Compile omap2 support only when needed

 arch/arm/configs/omap2plus_defconfig |    4 ++--
 drivers/video/Makefile               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.4.1

