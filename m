Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2DXHU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:20:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3076 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2DXHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:20:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Apr 2012 00:20:56 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: w.sang@pengutronix.de, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 0/2] i2c: tegra: 10 bit and M_NOSTART support
Date: Tue, 24 Apr 2012 12:49:34 +0530
Message-Id: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for i2c protocoal mangling M_NOSTART and
fixes bug for 10 bit address configuration.

Laxman Dewangan (2):
  i2c: tegra: fix 10bit address configuration
  i2c: tegra: support for I2C_M_NOSTART protocol mangling

 drivers/i2c/busses/i2c-tegra.c |   41 ++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 8 deletions(-)

