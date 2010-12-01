Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0LAUiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:38:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19554 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0LAUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:38:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Dec 2010 12:32:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <dahuang@nvidia.com>, <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 0/4] Various tps6586x regulator fixes from ChromeOS
Date: Wed, 1 Dec 2010 13:37:27 -0700
Message-ID: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are some patches for the tps6586x regulator driver that were
made in the ChromeOS repository.

A variety of people have built a kernel containing these patches, and
booted Tegra Seaboard with that kernel.

Danny Huang (4):
  regulator: tps6586x: Add missing bit mask generation
  regulator: tps6586x: Fix TPS6586X_DVM to store goreg/bit
  regulator: tps6586x: Handle both enable reg/bits being the same
  regulator: tps6586x: correct register table

 drivers/regulator/tps6586x-regulator.c |   33 +++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 11 deletions(-)

-- 
nvpublic

