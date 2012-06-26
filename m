Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2FZEAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:00:24 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:36339 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab2FZEAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:00:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAM8y6U9bdWOb/2dsb2JhbABEtiyBB4IYAX8wbSISiA+5JJE3A5UukAGCYQ
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="532687842"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 0/4] staging: sm7xxfb: code improvements and cleanup
Date: Tue, 26 Jun 2012 06:00:13 +0200
Message-Id: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patchset erases dead code mainly.

Javier M. Mellid (4):
  staging: sm7xxfb: dead code removal
  staging: sm7xxfb: dead code removal
  staging: sm7xxfb: delete unnecessary color map allocation
  staging: sm7xxfb: code cleanup on smtcfb_setmode

 drivers/staging/sm7xxfb/sm7xx.h   |    1 -
 drivers/staging/sm7xxfb/sm7xxfb.c |  100 +++++++++++++++----------------------
 2 files changed, 40 insertions(+), 61 deletions(-)

-- 
1.7.10

