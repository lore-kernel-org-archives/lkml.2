Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2F0MKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:10:22 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48897 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686Ab2F0MKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:10:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAIb36k9bdWOb/2dsb2JhbABFtHcEA4EogQeCGAF/MG0iEogPuUORQQOVMpADgmE
X-IronPort-AV: E=Sophos;i="4.77,484,1336341600"; 
   d="scan'208";a="533592650"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 0/2] staging: sm7xxfb: code improvements and cleanup
Date: Wed, 27 Jun 2012 14:10:13 +0200
Message-Id: <1340799015-3138-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patchset implements some code improvements and cleanup related to
smtcfb_info.

Tested with SM712.

Javier M. Mellid (2):
  staging: sm7xxfb: rename vars holding device and revision ids
  staging: sm7xxfb: erase hardcode cast between smtcfb_info and fb_info

 drivers/staging/sm7xxfb/sm7xxfb.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

-- 
1.7.10

