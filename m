Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1BGVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:17:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55254 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BGVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:17:04 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it
Subject: [PATCH 0/4] RTC: Updates for RTC.
Date: Mon,  7 Feb 2011 19:16:04 -0200
Message-Id: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches are updates to the RTC code to take into account
the new emulated periodic interrupts using hrtimers.

[PATCH 1/4] RTC: Include information about UIE and PIE in RTC driver proc.
[PATCH 2/4] RTC: Remove UIE and PIE information from the sa1100 driver proc.
[PATCH 3/4] RTC: Fix the cross interrupt issue on rtc-test.
[PATCH 4/4] RTC: sa1100: Update the sa1100 RTC driver.

 drivers/rtc/rtc-proc.c   |   22 ++++++---
 drivers/rtc/rtc-sa1100.c |  122 ++--------------------------------------------
 drivers/rtc/rtc-test.c   |   13 +++--
 3 files changed, 29 insertions(+), 128 deletions(-)

