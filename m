Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2GJAQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:16:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64343 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2GJAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:16:19 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/4] Calxeda xgmac fixes and performance improvements
Date: Mon,  9 Jul 2012 19:16:06 -0500
Message-Id: <1341879370-23385-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

A few fixes and performance improvements for the Calxeda xgmac driver for
3.6. It would be nice to get the 2 fixes into 3.5, but since it is a bit
late in the cycle they can wait.

Rob

Rob Herring (4):
  net: calxedaxgmac: fix net timeout recovery
  net: calxedaxgmac: fix hang on rx refill
  net: calxedaxgmac: set outstanding AXI bus transactions to 8
  net: calxedaxgmac: enable rx cut-thru mode

 drivers/net/ethernet/calxeda/xgmac.c |   35 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
1.7.9.5

