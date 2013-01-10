Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3AJNDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:03:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36365 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3AJNDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:03:01 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/2] LOW power sleep support for TI PWM submodules
Date: Thu, 10 Jan 2013 18:33:42 +0530
Message-ID: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI PWM sub modules like ECAP & EHRPWM can enter in low power sleep
state during low power transitions of the platforms (like in AM33XX).
This patch series support low power sleep transition support. This
patch series depend on [1] and [2] and tested for low sleep support
on AM335x-evm for ECAP based PWM backlight.

1. ARM: OMAP2+: AM33XX: Add suspend-resume support
   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg82635.html
2. HWMOD fixes for AM33xx PWM submodules and device tree nodes.
   https://lkml.org/lkml/2013/1/2/87

Philip Avinash (2):
  pwm: pwm-tiehrpwm: Low power sleep support
  pwm: pwm-tiecap: Low power sleep support

 drivers/pwm/pwm-tiecap.c   |   45 +++++++++++++++++++++++++++++
 drivers/pwm/pwm-tiehrpwm.c |   67 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

-- 
1.7.9.5

