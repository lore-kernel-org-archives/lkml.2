Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294Ab0HFLue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:50:34 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:53287 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab0HFLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:50:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 0/5] ARM: add PrimeCell generic DMA
Date: Fri, 6 Aug 2010 13:50:06 +0200
Message-ID: <1281095406-15534-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a ninth iteration of this patch set after
the updates to the DMAengine framework allowing for
generic runtime channel control which match the needs
of the PrimeCells.

DMA is working for PL011 serial on the PB11MPCore with
the posted PL08x driver, more testing on this later.
I'll likely post a patch set including the platform
data for PB11MPCore as well.

Yours,
Linus Walleij
