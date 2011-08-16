Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1HPFe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:34:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41884 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1HPFeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:34:24 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 0/4] Kbuild/Kconfig 
Date: Tue, 16 Aug 2011 01:34:10 -0400
Message-Id: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

The following small serie unexpose a few Kconfig variable from Kbuild, and
vice-versa. The idea is that Kbuild is a user of Kconfig, not the other way
around.

In the same time, fix a couple of place where we hardcode the `.config' string.

Comments Welcome !
 - Arnaud

Arnaud Lacombe (4):
  kbuild: introduce KBUILD_CONFIG; unexpose KCONFIG_CONFIG
  kbuild: reduce kbuild invasivity within kconfig
  kbuild: do not hardcode .config
  kconfig: do not hardcode .config

 Makefile                                |   20 ++++++++++++++------
 arch/arm/boot/compressed/Makefile       |    2 +-
 arch/unicore32/boot/compressed/Makefile |    2 +-
 scripts/kconfig/Makefile                |   31 ++++++++++++++++---------------
 4 files changed, 32 insertions(+), 23 deletions(-)

-- 
1.7.6.153.g78432

