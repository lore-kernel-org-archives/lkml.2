Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1BVQyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:54:00 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:45202 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185Ab1BVQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:53:59 -0500
Date: Tue, 22 Feb 2011 17:50:06 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA bugfixes for 2.6.38-rc6
Message-ID: <20110222165006.GB21778@comet.dominikbrodowski.net>
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

a few PCMCIA bugfixes have accumulated in the PCMCIA tree, so please pull
from

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The individual patches will be sent out (at least) to the PCMCIA list.

Thanks,
        Dominik


Alan Cox (1):
      cm4000_cs: Fix undefined ops warning

Dominik Brodowski (1):
      pcmcia: re-enable Zoomed Video support

Julia Lawall (1):
      drivers/char/pcmcia/ipwireless/main.c: Convert release_resource to release_region/release_mem_region

Pavel Machek (1):
      pcmcia vs. MECR on pxa25x/sa1111

 drivers/char/pcmcia/cm4000_cs.c       |    3 +-
 drivers/char/pcmcia/ipwireless/main.c |   52 ++++++++++++++++++++------------
 drivers/pcmcia/pcmcia_resource.c      |    2 +
 drivers/pcmcia/pxa2xx_base.c          |    2 +-
 drivers/pcmcia/pxa2xx_base.h          |    1 +
 drivers/pcmcia/pxa2xx_lubbock.c       |    1 +
 include/pcmcia/ds.h                   |    1 +
 7 files changed, 39 insertions(+), 23 deletions(-)
