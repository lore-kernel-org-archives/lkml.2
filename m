Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371Ab2ESOj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:39:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13015 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760337Ab2ESOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 19 May 2012 07:38:06 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] regulator: tps65910: fixes/cleanups in dt supports
Date: Sat, 19 May 2012 20:04:05 +0530
Message-ID: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the some parameter initialization and cleanup for dt support.
All patches are self explanatory.
- Use small names for the regulator name to match with doc
- initize of_node properly.
- pass proper device structure when registering regulator
- use dvm_*
- Add some more debug print info.

Laxman Dewangan (5):
  regulator: tps65910: use small letter for regulator names
  regulator: tps65910: set of_node for regulator register config
  regulator: tps65910:  use self device for regulator registration
  regulator: tps65910: use devm_* for memory allocation
  regulator: tps65910: add error message in case of failure

 drivers/regulator/tps65910-regulator.c |  165 ++++++++++++++++----------------
 1 files changed, 84 insertions(+), 81 deletions(-)

