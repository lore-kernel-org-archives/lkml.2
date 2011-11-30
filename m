Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1K3PfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:35:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51560 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1K3PfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:35:17 -0500
Message-ID: <4ED64D30.7090006@gmail.com>
Date: Wed, 30 Nov 2011 09:35:12 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE1vbGw=?= <Pawel.Moll@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PULL] Device Tree updates for 3.2-rc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

As Grant mentioned previously, he's offline for a sabbatical so I'm
gathering up DT patches for 3.2-rc. Not much here. 1 doc update and a
fix to handle reverted commit "of/irq: of_irq_find_parent: check for
parent equal to child" (dc9372808412edb) in different way. Please pull.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://sources.calxeda.com/kernel/linux.git dt-for-linus

Pawel Moll (1):
      of: Add Silicon Image vendor prefix

Rob Herring (1):
      of/irq: of_irq_init: add check for parent equal to child node

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/of/irq.c                                   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

Regards,
Rob
