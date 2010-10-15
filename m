Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab0JOEB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:01:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0JOEB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:01:28 -0400
Date: Fri, 15 Oct 2010 00:01:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        kyle@mcmartin.ca
Subject: [PATCH 0/4] cris: kill __do_IRQ
Message-ID: <20101015040127.GA6333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches remove the cris architectures calls to __do_IRQ.
They've been build tested on -v10 and -v32, but not boot tested. It
should be possible to bisect across the changes for both platforms.

 arch/cris/Kconfig                     |    3 ++
 arch/cris/arch-v10/kernel/irq.c       |   26 +++-------------
 arch/cris/arch-v32/kernel/irq.c       |   53 +++++++++------------------------
 arch/cris/include/arch-v32/arch/irq.h |    4 +-
 arch/cris/kernel/irq.c                |    2 +-
 5 files changed, 25 insertions(+), 63 deletions(-)

regards, Kyle M.
