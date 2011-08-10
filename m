Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HJODR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:03:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43182 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1HJODP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:03:15 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 0/2] omap3: ISP: Fix the failure of CCDC capture during suspend/resume
Date: Wed, 10 Aug 2011 19:32:59 +0530
Message-ID: <1312984979-19270-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the occasional failure of CCDC capture during 
suspend/resume.

Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Abhilash K V <abhilash.kv@ti.com>
---
Abhilash K V (2):
  omap3: ISP: Fix the failure of CCDC capture during suspend/resume
  omap3: ISP: Kernel crash when attempting suspend

 drivers/media/video/omap3isp/isp.c      |   22 +++++++++++-
 drivers/media/video/omap3isp/isp.h      |    4 ++
 drivers/media/video/omap3isp/ispvideo.c |   58 ++++++++++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispvideo.h |    2 +
 4 files changed, 84 insertions(+), 2 deletions(-)

