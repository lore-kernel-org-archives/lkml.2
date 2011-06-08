Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab1FHAIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:08:32 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:51156 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758935Ab1FHAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:08:30 -0400
From: Kevin Hilman <khilman@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        None <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] GPIO: OMAP fixes for v3.0-rc
Organization: Texas Instruments, Inc.
Date: Tue, 07 Jun 2011 17:08:27 -0700
Message-ID: <878vtdkww4.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Here's a small set of OMAP GPIO fixes for v3.0-rc.

Thanks,

Kevin



The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git for_3.0/gpio-fixes

Colin Cross (2):
      GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
      GPIO: OMAP: add locking around calls to _set_gpio_triggering

Russell King (1):
      GPIO: OMAP: fix section mismatch warnings

 drivers/gpio/gpio-omap.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)
