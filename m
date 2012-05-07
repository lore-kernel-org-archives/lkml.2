Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2EGMpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:45:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1898 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2EGMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:45:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 May 2012 05:45:33 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 0/2] regulator: tps62360: add cache support and settling time
Date: Mon,  7 May 2012 18:08:24 +0530
Message-Id: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is for improving the register update time by enabling
caching and provide settling time for voltage output change.

Creating this patch series by removing the stylistic fix as it
is under discussion and these changes can go independently.

Laxman Dewangan (2):
  regulator: tps62360: enable register cache
	Enable the caching of register to have faster update_bits as it
	will avoid one more i2c read every time.

  regulator: tps62360: Provide settling time for voltage change
	This will provide settlling delay when voltage output changes.

 drivers/regulator/tps62360-regulator.c |   52 +++++++++++++++++++++++++++-----
 1 files changed, 44 insertions(+), 8 deletions(-)

