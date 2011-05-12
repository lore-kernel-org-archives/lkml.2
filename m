Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1ELN2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:28:04 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37857 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab1ELN2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:28:00 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH v2 0/4] Add support for twl6025 PMIC
Date: Thu, 12 May 2011 14:27:54 +0100
Message-Id: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series starts to add support for the twl6025 chip to the
twl driver. This series contains patches for the MFD device and the
regulator device to support the twl6025.

Since V1

Series has been altered to pass features via platform data rather
than via a get function on a global variable.
Regulator style was change so some ifs were replaced with switch.
There has been some discussion about regulator definition and naming
and TI have agreed to take on the cleanup internally.

Graeme

