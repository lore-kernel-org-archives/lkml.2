Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1D0Jts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:49:48 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:52797 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1D0Jtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:49:43 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/4] Add support for twl6025 PMIC
Date: Wed, 27 Apr 2011 10:39:47 +0100
Message-Id: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series starts to add support for the twl6025 chip to the
twl driver. This series contains patches for the MFD device and the
regulator device to support the twl6025.

Graeme

