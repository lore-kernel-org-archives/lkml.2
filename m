Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422935Ab2KNNre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:47:34 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45627 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422757Ab2KNNrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:47:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Input related patches
Date: Wed, 14 Nov 2012 13:47:12 +0000
Message-Id: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have all already been on the MLs for some time now. I've
applied all of the Acks acquired and bunched them up into a
single patch-set for the convenience of the maintainer.

 .../devicetree/bindings/input/stmpe-keypad.txt     |   39 +++++++
 arch/arm/mach-ux500/board-mop500-stuib.c           |   70 +-----------
 drivers/input/keyboard/stmpe-keypad.c              |   67 +++++++++--
 drivers/input/touchscreen/bu21013_ts.c             |  117 +++++++++++++++++---
 drivers/mfd/stmpe.c                                |    1 +
 include/linux/input/bu21013.h                      |    8 +-
 6 files changed, 204 insertions(+), 98 deletions(-)

