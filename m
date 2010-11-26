Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0KZGpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 01:45:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37432 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0KZGpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 01:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qtWxTpFIJ3DB+TQzTwzf3RAykPRjzBKu7X2GBzpllESHAbFFqMHzR80Nwc6o+xAHLr
         Rga2f/eKjHmv+/IW9gStiHqtZJFtj2uPVyRWLdJ1gffE/n1ELaUAZ7zyPnQ3yShO/uPn
         oXjw+7NVUmZzkyW41anPG0pDmQZ2jAuMdCwz8=
Subject: [PATCH 0/4] Fixes resource leaks for Samsung SoCs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Graeme Gregory <graeme@openmoko.org>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Fri, 26 Nov 2010 14:50:45 +0800
Message-Id: <1290754245.25125.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial of patches fixes resource leaks for Samsung SoCs.

Axel Lin (4):
  ASoC: Fix resource leask in goni_wm8994.c
  ASoC: Fix resource leask in neo1973_gta02_init() error path
  ASoC: Add missing gpio_free(S3C64XX_GPK(12)) in smartq_exit()
  ASoC: Fix resource leask in smdk_spdif.c

 sound/soc/samsung/goni_wm8994.c          |    9 +++++++--
 sound/soc/samsung/neo1973_gta02_wm8753.c |   22 +++++++++++-----------
 sound/soc/samsung/smartq_wm8987.c        |    1 +
 sound/soc/samsung/smdk_spdif.c           |   13 +++++++++----
 4 files changed, 28 insertions(+), 17 deletions(-)

-- 
1.7.2



