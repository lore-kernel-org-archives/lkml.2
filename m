Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225Ab2JLPP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:15:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42004 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JLPPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:15:21 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: jonathan@jonmasters.org, eric.dumazet@gmail.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/6] Calxeda xgmac performance fixes
Date: Fri, 12 Oct 2012 10:15:02 -0500
Message-Id: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This is a series of performance improvements to the xgmac driver. The most
significant changes are the alignment fixes to avoid alignment traps on
received frames and using relaxed i/o accessors.

Rob

Rob Herring (6):
  net: calxedaxgmac: enable operate on 2nd frame mode
  net: calxedaxgmac: remove explicit rx dma buffer polling
  net: calxedaxgmac: use relaxed i/o accessors in rx and tx paths
  net: calxedaxgmac: drop some unnecessary register writes
  net: calxedaxgmac: rework transmit ring handling
  net: calxedaxgmac: ip align receive buffers

 drivers/net/ethernet/calxeda/Kconfig |    2 +-
 drivers/net/ethernet/calxeda/xgmac.c |   57 +++++++++++++++-------------------
 2 files changed, 26 insertions(+), 33 deletions(-)

-- 
1.7.9.5

