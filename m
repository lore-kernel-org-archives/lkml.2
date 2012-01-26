Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2AZQW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:22:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15613 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2AZQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:22:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jan 2012 08:22:25 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] Add support for LP3
Date: Thu, 26 Jan 2012 18:22:00 +0200
Message-Id: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce support for LP3 (CPU core clockgating) for Tegra20 and Tegra30.

Peter De Schrijver (3):
  ARM: tegra: definitions for flow controller
  ARM: tegra: assembler code for LP3
  ARM: tegra: cpuidle driver for tegra

 arch/arm/mach-tegra/Makefile   |    2 +
 arch/arm/mach-tegra/cpuidle.c  |  107 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/flowctrl.h |   37 ++++++++++++++
 arch/arm/mach-tegra/sleep.S    |   91 ++++++++++++++++++++++++++++++++++
 4 files changed, 237 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/cpuidle.c
 create mode 100644 arch/arm/mach-tegra/flowctrl.h
 create mode 100644 arch/arm/mach-tegra/sleep.S

-- 
1.7.7.rc0.72.g4b5ea.dirty

