Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2KILpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:45:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42166 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KILpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:45:51 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, patches@linaro.org
Subject: [PATCH 0/8] Fix coding style in sdhci.c
Date: Fri,  9 Nov 2012 17:09:50 +0530
Message-Id: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents/CodingStyle Chapter 3 recommends usage of braces for both
if and else statements if any of the branches contains multiple
statements.

Cleaning up drivers/mmc/host/sdhci.c for all these occurrences.

Tushar Behera (8):
  mmc: sdhci: fix coding style in sdhci_calc_timeout
  mmc: sdhci: fix coding style in sdhci_set_transfer_mode
  mmc: sdhci: fix coding style in sdhci_finish_data
  mmc: sdhci: fix coding style in sdhci_set_clock
  mmc: sdhci: fix coding style in sdhci_do_set_ios
  mmc: sdhci: fix coding style in sdhci_execute_tuning
  mmc: sdhci: fix coding style in sdhci_data_irq
  mmc: sdhci: fix coding style in sdhci_add_host

 drivers/mmc/host/sdhci.c |   58 +++++++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 26 deletions(-)

-- 
1.7.4.1

