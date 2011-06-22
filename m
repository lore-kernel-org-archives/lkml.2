Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1FVVLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:11:20 -0400
Received: from smtp-out-224.synserver.de ([212.40.185.224]:1068 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758922Ab1FVVLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23094
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/4] ASoC: Add adav* drivers to the Analog Devices file patterns
Date: Wed, 22 Jun 2011 23:09:56 +0200
Message-Id: <1308776997-12959-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1308776997-12959-1-git-send-email-lars@metafoo.de>
References: <1308776997-12959-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a26e9ec..4f7665c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -534,6 +534,7 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
 S:	Supported
 F:	sound/soc/codecs/adau*
+F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/ssm*
 
-- 
1.7.2.5

