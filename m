Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0IPNus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:50:48 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:59598 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754888Ab0IPNuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:50:46 -0400
Date: Thu, 16 Sep 2010 15:50:35 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA bugfixes for 2.6.36-rc5
Message-ID: <20100916135035.GA20989@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

in order to solve a severe bug rendering many serial PCMCIA cards
unuseable, and to let pcnet_cs work on more cards, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Thanks,
	Dominik

Dominik Brodowski (3):
      pcmcia serial_cs.c: fix multifunction card handling
      pcmcia: per-device, not per-socket debug messages
      pcmcia pcnet_cs: try setting io_lines to 16 if card setup fails

 drivers/net/pcmcia/pcnet_cs.c    |  139 ++++++++++++++++++++++---------------
 drivers/pcmcia/pcmcia_resource.c |   51 +++++++-------
 drivers/serial/serial_cs.c       |   62 ++++++++++-------
 3 files changed, 146 insertions(+), 106 deletions(-)
