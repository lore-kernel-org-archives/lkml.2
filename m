Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1GJPgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:36:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33989 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1GJPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:15 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: [PATCH 0/10] staging: et131x: Kernel coding style cleanups
Date: Sun, 10 Jul 2011 16:35:25 +0100
Message-Id: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly sanitising function and variable names to bring them
more inline with the kernel coding style.

Mark Einon (11):
 staging: et131x: Converting et1310_mac.c function and
 staging: et131x: Converting et1310_phy.c function and
 staging: et131x: Converting et1310_pm.c function and
 staging: et131x: Remove unecessary *etdev NULL check
 staging: et131x: Converting et1310_rx.c function and
 staging: et131x: Make static some local functions in
 staging: et131x: Converting et1310_rx.h variable names
 staging: et131x: add et1310_ prefix to et1310_mac.c
 staging: et131x: Converting et1310_tx.c function and
 staging: et131x: Converting et1310_adapter.h variable

 drivers/staging/et131x/et1310_mac.c     |  251 ++++++++--------
 drivers/staging/et131x/et1310_phy.c     |  449 +++++++++++++-------------
 drivers/staging/et131x/et1310_pm.c      |   16 +-
 drivers/staging/et131x/et1310_rx.c      |  523 ++++++++++++++++---------------
 drivers/staging/et131x/et1310_rx.h      |   62 ++--
 drivers/staging/et131x/et1310_tx.c      |  302 +++++++++---------
 drivers/staging/et131x/et131x.h         |   69 ++---
 drivers/staging/et131x/et131x_adapter.h |   91 +++---
 drivers/staging/et131x/et131x_initpci.c |   84 +++---
 drivers/staging/et131x/et131x_isr.c     |   25 +-
 drivers/staging/et131x/et131x_netdev.c  |   79 +++---
 11 files changed, 975 insertions(+), 976 deletions(-)

