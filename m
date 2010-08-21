Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0HUMbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 08:31:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33177 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0HUMat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 08:30:49 -0400
From: hvaibhav@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, felipe.balbi@nokia.com,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 0/3] RTC:A35390A: Add Interrupt API interfaces
Date: Sat, 21 Aug 2010 18:00:26 +0530
Message-Id: <1282393829-7326-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

This patch adds support for interrupt API interfaces like,
	- Alarm interrupt
	- Periodic interrupt
	- Per minute interrupt

Changes from V1 :-
	- Converted work-queue to threaded irq
	- Fixed comments from Felipe Balbi

Vaibhav Hiremath (3):
  RTC:s35390a: Add Alarm interrupt support
  RTC:s35390a: Add Periodic interrupt support
  RTC:s35390a: Add update_irq (per Min interrupt) support

 drivers/rtc/rtc-s35390a.c |  281 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 278 insertions(+), 3 deletions(-)

