Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2FOKWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:22:04 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50513 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab2FOKWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:22:01 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.ujfalusi@ti.com
Subject: [PATCH 0/2] Input: twl*-vibra probe cleanups (devm_* conversion)
Date: Fri, 15 Jun 2012 13:22:10 +0300
Message-Id: <1339755732-23774-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Convert the twl4030, twl6040 vibra drivers to use devm_ at probe time to clean
up the code a bit.
The twl6040-vibra driver needed bigger change since the ordering of the
initialization was not correct.

Regards,
Peter
---
Peter Ujfalusi (2):
  Input: twl4030-vibra: Convert to use devm_* in probe
  Input: twl6040-vibra: Code cleanup in probe with devm_* conversion

 drivers/input/misc/twl4030-vibra.c |    8 +--
 drivers/input/misc/twl6040-vibra.c |   99 ++++++++++++++++-------------------
 2 files changed, 47 insertions(+), 60 deletions(-)

-- 
1.7.8.6

