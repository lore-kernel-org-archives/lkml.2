Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2CMGK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:10:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9115 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2CMGKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:10:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 12 Mar 2012 23:10:24 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 0/2] Settling time for rails on/voltage change
Date: Tue, 13 Mar 2012 11:35:19 +0530
Message-Id: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Settling time is require to stabilize output when either switched to ON
or change voltage.
These patch set provide the settling delay when switch to ON or when doing
voltage change.

Laxman Dewangan (2):
  regulator: tps65910: Provide settling time for enabling rails.
Settling time for switching to ON. 
  regulator: tps65910: Provide settling time for DCDC voltage change
Settling time for stabilizing voltage output of DCDC rail.


 drivers/regulator/tps65910-regulator.c |   82 +++++++++++++++++++++++++++-----
 1 files changed, 69 insertions(+), 13 deletions(-)

