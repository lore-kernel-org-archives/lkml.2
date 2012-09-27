Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2I0PMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:12:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47543 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2I0PMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:12:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/7] Next instalment of Device Tree work for ST-Ericsson
Date: Thu, 27 Sep 2012 16:11:59 +0100
Message-Id: <1348758726-25336-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contained in this patch are some serious clean-ups for HREF related
Device Tree code. We make clear definition between pre-v60 and post-
v60 HREFs with the creation of their own DTS files. We also start to
take out most of the device registration calls which were duplicated
to aid with step-by-step DT enablement. There are also some small
fixes for the Snowball DTS which were uncovered during this
enablement phase.

  arch/arm/boot/dts/dbx5x0.dtsi      |   12 +-
  arch/arm/boot/dts/href.dtsi        |  274 ++++++++++++++++++++++++++++++++++++
  arch/arm/boot/dts/hrefprev60.dts   |   31 ++++
  arch/arm/boot/dts/hrefv60plus.dts  |  210 +--------------------------
  arch/arm/boot/dts/snowball.dts     |    6 +-
  arch/arm/mach-ux500/board-mop500.c |   24 ----
  6 files changed, 318 insertions(+), 239 deletions(-)

