Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1CAA4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:56:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3859 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1CAA4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:56:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 28 Feb 2011 16:56:39 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/4] power: bq20z75: update support
Date: Mon, 28 Feb 2011 16:55:27 -0800
Message-Id: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Adds support to driver for the following:
* optional gpio for battery detection
* optional retries for i2c I/O failures
* POWER_NOW property

For more detailed information, see specifics patches.

Rhyland Klein (4):
  power: bq20z75: add optional battery detect gpio
  power: bq20z75: add i2c retry mechanism
  power: bq20z75: add support for POWER_NOW
  power_supply: update power_supply_is_watt_property

 drivers/power/bq20z75.c       |  226 ++++++++++++++++++++++++++++++++++-------
 include/linux/power/bq20z75.h |   39 +++++++
 include/linux/power_supply.h  |    1 +
 3 files changed, 230 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/power/bq20z75.h

