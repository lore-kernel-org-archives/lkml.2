Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2C1HPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:15:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49569 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2C1HOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:46 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/5] drivers/clk: common clock framework
Date: Wed, 28 Mar 2012 00:14:02 -0700
Message-Id: <1332918842-13521-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains patches from Mike Turquette adding a common clock
framework to be shared across platforms. This is part of the work towards
building a common zImage for several ARM platforms.



-Olof

----------------------------------------------------------------

The following changes since commit 414ed6be101239798330565ce49e7ca0fdfdba04:

  Merge tag 'dt2' into for-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/common-clk-api

for you to fetch changes up to 8fb61e33507e5d76b69467b4f96290338e96b733:

  clk: make CONFIG_COMMON_CLK invisible

----------------------------------------------------------------

Arnd Bergmann (1):
      clk: make CONFIG_COMMON_CLK invisible

Mike Turquette (3):
      Documentation: common clk API
      clk: introduce the common clock framework
      clk: basic clock hardware types


 Documentation/clk.txt        |  233 ++++++
 drivers/clk/Kconfig          |   37 +
 drivers/clk/Makefile         |    2 +
 drivers/clk/clk-divider.c    |  200 +++++
 drivers/clk/clk-fixed-rate.c |   82 +++
 drivers/clk/clk-gate.c       |  150 ++++
 drivers/clk/clk-mux.c        |  116 +++
 drivers/clk/clk.c            | 1461 +++++++++++++++++++++++++++++++++++++
 include/linux/clk-private.h  |  196 +++++
 include/linux/clk-provider.h |  300 ++++++++
 include/linux/clk.h          |   68 +-
 11 files changed, 2840 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/clk.txt
 create mode 100644 drivers/clk/clk-divider.c
 create mode 100644 drivers/clk/clk-fixed-rate.c
 create mode 100644 drivers/clk/clk-gate.c
 create mode 100644 drivers/clk/clk-mux.c
 create mode 100644 drivers/clk/clk.c
 create mode 100644 include/linux/clk-private.h
 create mode 100644 include/linux/clk-provider.h
