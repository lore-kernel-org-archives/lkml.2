Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2JJPTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:19:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64154 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab2JJPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/6] Provide basic support for the u9540
Date: Wed, 10 Oct 2012 16:18:49 +0100
Message-Id: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch-set has been applied the Mainline kernel
successfully boots on the u9540 development board. It is
by no means fully enabled, but it does provide solid
foundations for further development.

 arch/arm/boot/dts/u9540.dts      |   47 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/cpu-db8500.c |   15 +++++++++++-
 drivers/mfd/db8500-prcmu.c       |    8 +++++--
 3 files changed, 67 insertions(+), 3 deletions(-)

