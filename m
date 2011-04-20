Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1DTMJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:09:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8002 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1DTMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:09:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Apr 2011 05:09:48 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, ben-linux@fluff.org, lucas.demarchi@profusion.mobi,
        ccross@android.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
Date: Wed, 20 Apr 2011 20:08:30 +0800
Message-Id: <1303301312-15302-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

*** BLURB HERE ***

Wei Ni (2):
  i2c: tegra: Retry transfer when unexpected/no_ack status is detected
  i2c: tegra: use new i2c slave controller

 drivers/i2c/busses/i2c-tegra.c |   57 +++++++++++++++++++++++++++++++++++++--
 include/linux/i2c-tegra.h      |    3 ++
 2 files changed, 57 insertions(+), 3 deletions(-)

