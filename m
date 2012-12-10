Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2LJI4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:56:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44568 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2LJI4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: [PATCH 00/12] Functionality add and bug-fixes related to MMCI regulators
Date: Mon, 10 Dec 2012 08:55:49 +0000
Message-Id: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patch-set is to move the MMCI's secondary
(platform specific) regulator implementation out of platform code
and into use the regulator frame-work. A few bugs were encountered
along the way, so we've fixed those too and bundled them in for
completeness.

 arch/arm/boot/dts/dbx5x0.dtsi          |    7 ++--
 arch/arm/boot/dts/href.dtsi            |    1 +
 arch/arm/boot/dts/hrefprev60.dts       |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c |   52 ---------------------------
 arch/arm/mach-ux500/board-mop500.c     |   61 ++++++++++++++++++++++++++++++++
 drivers/mmc/host/mmci.c                |   18 ++++++++--
 drivers/mmc/host/mmci.h                |    1 +
 drivers/regulator/gpio-regulator.c     |   17 ++++++---
 8 files changed, 96 insertions(+), 63 deletions(-)

