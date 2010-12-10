Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0LJD5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:57:02 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49544 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0LJD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:57:00 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <felipe.contreras@gmail.com>, <nm@ti.com>,
        <ohad@wizery.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 0/4] staging: tidspbridge - misc fixes
Date: Thu,  9 Dec 2010 21:55:38 -0600
Message-Id: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* V2
 - rebase to the latest
 - remove patches no needed at this moment

This set of patches fix some issues found in lastest tree.

Fernando Guzman Lugo (4):
  staging: tidspbridge - use GTP7 for DSP stack dump
  staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
  staging: tidspbridge - remove disabling twl when printing DSP stack
  staging: tidspbridge - change mmufault tasklet to a workqueue

 drivers/staging/tidspbridge/core/_deh.h            |    2 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |   17 ++++---
 drivers/staging/tidspbridge/core/ue_deh.c          |   55 +++++++++++--------
 .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +-
 4 files changed, 46 insertions(+), 32 deletions(-)

-- 
1.7.3.2

