Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0HIMHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:07:38 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42498 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028Ab0HIMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:07:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 00/14] DMAENGINE: ste_dma40: bugfixes and enhancements
Date: Mon, 9 Aug 2010 14:07:26 +0200
Message-ID: <1281355646-12941-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a few bugfixes and some enhancements to the
DMA40 driver. Most should be pretty straight forward, others are
more elaborate, like the amendments to extend hw job lists at
runtime if there is already a queued job.

We know we're in the merge window, it's not like the world will
collapse if this has to wait for the next release cycle.

Yours,
Linus Walleij <linus.walleij@stericsson.com>
