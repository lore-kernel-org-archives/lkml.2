Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1EVUVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:21:18 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:44439 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1EVUVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:21:12 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, lrg@slimlogic.co.uk, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux@slimlogic.co.uk,
        balajitk@ti.com
Subject: [PATCH v4 0/1] Add support for twl6025 PMIC
Date: Sun, 22 May 2011 21:21:22 +0100
Message-Id: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series starts to add support for the twl6025 chip to the
twl driver. This series contains patches for the MFD device and the
regulator device to support the twl6025.

Since V3

Addressed some comments from Balaji T K, changed dcdc references to smps.
And rebased on top of new upstream driver.

Since V2

MFD patches have been accepted. Review comments have been addressed
in the regulator driver. twl6025 doesnt use remap so dont define it.

Since V1

Series has been altered to pass features via platform data rather
than via a get function on a global variable.
Regulator style was change so some ifs were replaced with switch.
There has been some discussion about regulator definition and naming
and TI have agreed to take on the cleanup internally.

