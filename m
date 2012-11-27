Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2K0NNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:13:20 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44764 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2K0NNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:13:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/3] Input: bu21013_ts - fixups and DT enablement
Date: Tue, 27 Nov 2012 13:13:07 +0000
Message-Id: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grouped together for easy tracking.

 arch/arm/mach-ux500/board-mop500-stuib.c |   71 +-------------------
 drivers/input/touchscreen/bu21013_ts.c   |  105 +++++++++++++++++++++++-------
 include/linux/input/bu21013.h            |    9 +--
 3 files changed, 85 insertions(+), 100 deletions(-)

