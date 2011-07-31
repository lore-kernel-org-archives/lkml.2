Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1GaIs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 04:48:59 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:50853 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751280Ab1GaIsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 04:48:53 -0400
Date: Sun, 31 Jul 2011 10:46:28 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 3.1
Message-ID: <20110731084628.GA5637@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few PCMCIA updates for 3.1 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik


Dominik Brodowski (1):
      smc91c92_cs.c: fix bogus compiler warning

Jonathan Cameron (3):
      drivers:pcmcia:soc_common: make socket_init and socket_suspend optional
      pcmcia: pxa2xx: remove empty socket_init / socket_resume functions.
      pxa2xx pcmcia - stargate 2 use gpio array.

Pavel Roskin (3):
      pcmcia: add PCMCIA_DEVICE_MANF_CARD_PROD_ID3
      hostap_cs: support cards with "Version 01.02" as third product ID
      orinoco_cs: be more careful when matching cards with ID 0x0156:0x0002

 drivers/net/pcmcia/smc91c92_cs.c          |    2 +-
 drivers/net/wireless/hostap/hostap_cs.c   |    2 +
 drivers/net/wireless/orinoco/orinoco_cs.c |    5 +++-
 drivers/pcmcia/pxa2xx_balloon3.c          |   10 --------
 drivers/pcmcia/pxa2xx_cm_x255.c           |   11 ---------
 drivers/pcmcia/pxa2xx_cm_x270.c           |   11 ---------
 drivers/pcmcia/pxa2xx_colibri.c           |   11 ---------
 drivers/pcmcia/pxa2xx_mainstone.c         |   10 --------
 drivers/pcmcia/pxa2xx_palmld.c            |   11 ---------
 drivers/pcmcia/pxa2xx_palmtc.c            |   11 ---------
 drivers/pcmcia/pxa2xx_palmtx.c            |   11 ---------
 drivers/pcmcia/pxa2xx_stargate2.c         |   34 +++++++++-------------------
 drivers/pcmcia/pxa2xx_viper.c             |   10 --------
 drivers/pcmcia/soc_common.c               |    7 +++--
 include/pcmcia/device_id.h                |    9 +++++++
 15 files changed, 31 insertions(+), 124 deletions(-)
