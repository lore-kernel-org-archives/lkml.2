Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2CJVge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:36:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35098 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2CJVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:36:31 -0500
From: Alan Ott <alan@signal11.us>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/2] ata: AT91 ata driver requires specific platforms
Date: Sat, 10 Mar 2012 16:36:20 -0500
Message-Id: <1331415380-10928-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331405617-4053-1-git-send-email-alan@signal11.us>
References: <1331405617-4053-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on suggestions from Ben Dooks, This patch now adds an AT91_HAS_PATA
kconfig item and the AT91 CPUs which have PATA now select it. The
AT91 PATA driver how depends on this kconfig item.

Ben, let me know if this is what you had in mind.


Alan Ott (2):
  ARM: AT91: Add parameter for AT91_HAS_PATA
  ata: AT91 ata driver requires AT91_HAS_PATA

 arch/arm/mach-at91/Kconfig |   11 +++++++++++
 drivers/ata/Kconfig        |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

