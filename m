Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2ENKx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2ENKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:25 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Mon, 14 May 2012 19:54:24 +0900
Message-Id: <20120514105424.8596.38355.sendpatchset@w520>
Subject: [PATCH 00/03] ARM: mach-shmobile: DT_MACHINE and mach-type updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: mach-shmobile: DT_MACHINE and mach-type updates

[PATCH 01/03] mach-shmobile: Use DT_MACHINE for KZM9G
[PATCH 02/03] mach-shmobile: Use DT_MACHINE for armadillo 800 eva
[PATCH 03/03] ARM: Undelete KZM9D mach-type

These patches contain a few last minute updates for mach-shmobile.
There are two patches that convert recently added boards to make use
of DT_MACHINE_START(). Also, slightly unrelated to the new boards,
but the KZM9D mach-type is undeleted as well. This to allow build
of the EMEV2-based KZM9D board.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies to linux-next 20120514

 arch/arm/boot/dts/r8a7740-armadillo800eva.dts  |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/sh73a0-kzm9g.dts             |   22 ++++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig                 |    2 ++
 arch/arm/mach-shmobile/board-armadillo800eva.c |    8 +++++++-
 arch/arm/mach-shmobile/board-kzm9g.c           |    8 +++++++-
 arch/arm/tools/mach-types                      |    1 +
 6 files changed, 61 insertions(+), 2 deletions(-)
