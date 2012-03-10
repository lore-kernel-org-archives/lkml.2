Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2CJXPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:15:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60490 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2CJXO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:14:58 -0500
From: Alan Ott <alan@signal11.us>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Alan Ott <alan@signal11.us>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/1] ARM: AT91: cleanup patches from Arnd Bergmann
Date: Sat, 10 Mar 2012 18:14:41 -0500
Message-Id: <1331421281-11570-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331405049-3186-1-git-send-email-alan@signal11.us>
References: <1331405049-3186-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of the patchset.
	* NO_IOPORT for RM9200 patch has been removed.
	* Hopefully all the right people are on this one.

Arnd Bergmann (1):
  ARM: at91: Use proper __iomem annotations

 arch/arm/mach-at91/at91rm9200.c            |    2 +-
 arch/arm/mach-at91/include/mach/hardware.h |    4 ++++
 arch/arm/mach-at91/setup.c                 |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

