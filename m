Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0KMQ0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:26:13 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:58562 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752747Ab0KMQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:26:12 -0500
Date: Sat, 13 Nov 2010 17:25:07 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: akpm@linux-foundation.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA bugfixes for 2.6.37-rc1
Message-ID: <20101113162507.GA13542@comet.dominikbrodowski.net>
Mail-Followup-To: akpm@linux-foundation.org, torvalds@osdl.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few PCMCIA bugfixes and improvements are available at

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patches were sent out at least
to linux-pcmcia a couple of days ago.

Thanks,
        Dominik


Andres Salomon (1):
      pcmcia: fix warning in synclink driver

Joe Perches (1):
      drivers/pcmcia/soc_common.c: Use printf extension %pV

Komuro (1):
      pd6729: Coding Style fixes

Nicolas Kaiser (1):
      pcmcia/cm4000: fix error code

Uwe Kleine-König (1):
      pcmcia/sa1100: don't put machine specific init functions in .init.text

 drivers/char/pcmcia/cm4000_cs.c   |    3 ++-
 drivers/char/pcmcia/synclink_cs.c |    1 +
 drivers/pcmcia/pd6729.c           |    8 ++++----
 drivers/pcmcia/pd6729.h           |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c   |    2 +-
 drivers/pcmcia/sa1100_assabet.c   |    2 +-
 drivers/pcmcia/sa1100_cerf.c      |    2 +-
 drivers/pcmcia/sa1100_generic.c   |    2 +-
 drivers/pcmcia/sa1100_h3600.c     |    2 +-
 drivers/pcmcia/sa1100_shannon.c   |    2 +-
 drivers/pcmcia/sa1100_simpad.c    |    2 +-
 drivers/pcmcia/soc_common.c       |    9 +++++++--
 12 files changed, 22 insertions(+), 15 deletions(-)
