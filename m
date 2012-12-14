Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2LNFsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:48:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63699 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LNFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:48:49 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Fri, 14 Dec 2012 14:53:23 +0900
Message-Id: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 00/08] clocksource: sh_cmt: CMT driver update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource: sh_cmt: CMT driver update

[PATCH 01/08] clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
[PATCH 02/08] clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
[PATCH 03/08] clocksource: sh_cmt: Consolidate platform_set_drvdata() call
[PATCH 04/08] clocksource: sh_cmt: Introduce per-register functions
[PATCH 05/08] clocksource: sh_cmt: CMSTR and CMCSR register access update
[PATCH 06/08] clocksource: sh_cmt: CMCNT and CMCOR register access update
[PATCH 07/08] clocksource: sh_cmt: Add control register callbacks
[PATCH 08/08] clocksource: sh_cmt: Add CMT register layout comment

This patch series contains a couple of driver updates from Kuribayashi-san
together with some register access changes from me. The register access
changes work towards adding support for 32-bit only CMT hardware, but
the final bits are not yet included in this series due to lack of hardware.

Patches 1-3:
Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Signed-off-by: Magnus Damm <damm@opensource.se>

Patches 4-8:
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |  257 ++++++++++++++++++++++++------------------
 1 file changed, 152 insertions(+), 105 deletions(-)


