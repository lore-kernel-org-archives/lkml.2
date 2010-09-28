Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0I1Oe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:34:27 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:36310 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0I1Oe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:34:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] PrimeCell Generic DMA v12 
Date: Tue, 28 Sep 2010 16:33:54 +0200
Message-ID: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still haven't acquired a PB926 Versatile board so rebasing
the patches in the hopes that one will appear.

- Fixed the #ifdefs to be switching on CONFIG_DMA_ENGINE
  rather than CONFIG_DMADEVICES, we're actually dependent
  on the engine leading to the compilation problem Grant
  saw under certain conditions.
  (This is how it was once in the past before I tried to
   be clever)
- Rebased the PL180 extension on top of the out-of-order
  IRQ arrival patch submitted earlier (so that one is
  required).

I can post a complete set of patches that add the PL08x
driver, the MMCI updates pending in Russells tracker
and this stack in case there is interest, but this is
trying to keep it as small as possible.

Yours,
Linus Walleij

