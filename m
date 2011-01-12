Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1ALSUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:20:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57780 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ALSUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:20:09 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [FYI 0/4] arm: mmci: example implementation of double buffering
Date: Wed, 12 Jan 2011 19:19:39 +0100
Message-Id: <1294856383-14187-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmci host driver implementation for double buffering is not intended
nor ready for mainline yet. It is only an example of how to implement
pre_req() and post_req(). The reason for this is that the basic DMA
support for MMCI is not complete yet.

This patch series depends on
"[PATCH 0/5] mmc: add double buffering for mmc block requests"

Linus Walleij (1):
  mmci: add PrimeCell generic DMA to MMCI/PL180

Per Forlin (1):
  ARM: mmci: add support for double buffering

Ulf Hansson (2):
  mmci: fixup broken_blockend variant patch
  MMCI: Corrections for DMA

 drivers/mmc/host/mmci.c   |  538 ++++++++++++++++++++++++++++++++++++++-------
 drivers/mmc/host/mmci.h   |   21 ++-
 include/linux/amba/mmci.h |   16 ++
 3 files changed, 496 insertions(+), 79 deletions(-)

