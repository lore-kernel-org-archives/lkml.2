Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2KUCen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:34:43 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2KUC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 15/42] ARM: shmobile: Select PINCTRL
Date: Wed, 21 Nov 2012 03:27:16 +0100
Message-Id: <1353464863-10281-16-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin control framework is required by mach-shmobile. Select it in
Kconfig.

This will be required when the sh-pfc driver will move to
drivers/pinctrl/.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..3eaa434 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -693,6 +693,7 @@ config ARCH_SHMOBILE
 	select MULTI_IRQ_HANDLER
 	select NEED_MACH_MEMORY_H
 	select NO_IOPORT
+	select PINCTRL
 	select PM_GENERIC_DOMAINS if PM
 	select SPARSE_IRQ
 	help
-- 
1.7.8.6

