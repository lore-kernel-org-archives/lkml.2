Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2IRSMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:12:38 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:56263 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab2IRSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:12:33 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/2] omap-dt: Add I2C bindings for am33xx
Date: Wed, 19 Sep 2012 19:07:58 +0300
Message-Id: <1348070880-23390-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT I2C bindings for am33xx platforms, as well as rename the
instances to what is used in the TRM.

The patch series is against linux-omap-dt for_3.7/dts_part2

Pantelis Antoniou (2):
  arm/dts: AM33XX: I2C DT bindings for the bone.
  am33xx: DT convert I2C from OMAP to am33xx names

 arch/arm/boot/dts/am335x-bone.dts | 45 ++++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/am335x-evm.dts  |  2 +-
 arch/arm/boot/dts/am33xx.dtsi     |  6 +++---
 3 files changed, 48 insertions(+), 5 deletions(-)

-- 
1.7.12

