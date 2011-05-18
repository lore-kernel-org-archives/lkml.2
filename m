Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1ERSdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:33:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39659 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab1ERSdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:33:02 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, linux@slimlogic.co.uk, lrg@ti.com
Subject: [PATCH v3 0/2] Add support for twl6025 PMIC
Date: Wed, 18 May 2011 19:32:48 +0100
Message-Id: <1305743570-12074-1-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series starts to add support for the twl6025 chip to the
twl driver. This series contains patches for the MFD device and the
regulator device to support the twl6025.

Since V2

MFD patches have been accepted. Review comments have been addressed
in the regulator driver. twl6025 doesnt use remap so dont define it.

Since V1

Series has been altered to pass features via platform data rather
than via a get function on a global variable.
Regulator style was change so some ifs were replaced with switch.
There has been some discussion about regulator definition and naming
and TI have agreed to take on the cleanup internally.

