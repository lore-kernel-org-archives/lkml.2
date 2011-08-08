Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1HHMu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:50:26 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64044 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1HHMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:50:25 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        u.kleine-koenig@pengutronix.de
Subject: [RESEND][PATCH 0/2] mxs-dma: Bugfixes for mxs-dma originally sent in April
Date: Mon,  8 Aug 2011 14:47:45 +0200
Message-Id: <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
References: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm resending two bugfixes for the mxs-dma driver, that I had
originally sent in April which were acked by Shawn Guo and Uwe
Kleine-König, but obviously were not picked up by any maintainer.


Best regards,
Lothar Waßmann
---
 drivers/dma/mxs-dma.c |    3 ++-
 drivers/dma/mxs-dma.c |   45 ++++++++++++++++++++++++---------------------
 2 files changed, 26 insertions(+), 22 deletions(-)
