Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2FFJLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:11:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58246 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FFJLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:11:41 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 0/2] some minor clk fixes
Date: Wed, 6 Jun 2012 14:41:29 +0530
Message-ID: <1338973891-28719-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

These are a couple of fixes I found while testing my
OMAP clock port.

regards,
Rajendra

Rajendra Nayak (2):
  clk: cache parent clocks only for muxes
  clk: Allow late cache allocation for clk->parents

 drivers/clk/clk.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

