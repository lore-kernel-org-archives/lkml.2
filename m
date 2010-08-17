Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0HQIvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:51:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57024 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab0HQIsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:48:55 -0400
From: hvaibhav@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/3] RTC:A35390A: Add Interrupt API interfaces
Date: Tue, 17 Aug 2010 14:18:38 +0530
Message-Id: <1282034921-22167-1-git-send-email-hvaibhav@ti.com>
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

Vaibhav Hiremath (3):
  RTC:s35390a: Add Alarm interrupt support
  RTC:s35390a: Add Periodic interrupt support
  RTC:s35390a: Add update_irq (per Min interrupt) support

 drivers/rtc/rtc-s35390a.c |  302 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 299 insertions(+), 3 deletions(-)

