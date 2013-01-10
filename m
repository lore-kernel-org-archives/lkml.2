Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3AJNgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:36:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37766 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab3AJNgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:36:16 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH resend 0/2] Input: twl*-vibra probe cleanups (devm_* conversion)
Date: Thu, 10 Jan 2013 14:36:03 +0100
Message-ID: <1357824965-30614-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

This series seams to got lost:
https://lkml.org/lkml/2012/6/15/128

Can you take it for 3.9?

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

 drivers/input/misc/twl4030-vibra.c |  8 +--
 drivers/input/misc/twl6040-vibra.c | 99 +++++++++++++++++---------------------
 2 files changed, 47 insertions(+), 60 deletions(-)

-- 
1.8.1

