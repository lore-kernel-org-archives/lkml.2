Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0CZQZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:25:36 -0400
Received: from isilmar.linta.de ([213.133.102.198]:57862 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752418Ab0CZQZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:25:35 -0400
Date: Fri, 26 Mar 2010 17:25:27 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.34-rc3
Message-ID: <20100326162527.GA5192@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

some PCMCIA bugfixes for 2.6.34-rc3 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Please pull from that location. The diffstat and list of changes follows.
The PM-related change is ACKed by Rafael and needed for the PCMCIA bugfix.

Thanks,
	Dominik

----

Dominik Brodowski (4):
      pcmcia: do not use ioports < 0x100 on x86
      pcmcia: allow for four multifunction subdevices (again)
      power: support _noirq actions on device types and classes
      pcmcia: use dev_pm_ops for class pcmcia_socket_class

Komuro (1):
      pd6729: Coding Style fixes

 drivers/base/power/main.c       |   31 ++++++++++
 drivers/pcmcia/at91_cf.c        |    2 -
 drivers/pcmcia/au1000_generic.c |   13 ----
 drivers/pcmcia/bfin_cf_pcmcia.c |   12 ----
 drivers/pcmcia/cs.c             |  124 ++++++++++++++++++++-------------------
 drivers/pcmcia/db1xxx_ss.c      |   27 ---------
 drivers/pcmcia/ds.c             |    8 ++-
 drivers/pcmcia/i82092.c         |   16 -----
 drivers/pcmcia/i82365.c         |   11 ----
 drivers/pcmcia/m32r_cfc.c       |   11 ----
 drivers/pcmcia/m32r_pcc.c       |   12 ----
 drivers/pcmcia/m8xx_pcmcia.c    |   17 -----
 drivers/pcmcia/omap_cf.c        |   12 ----
 drivers/pcmcia/pd6729.c         |   80 ++++++++++++-------------
 drivers/pcmcia/pxa2xx_base.c    |    8 +--
 drivers/pcmcia/rsrc_nonstatic.c |    7 ++
 drivers/pcmcia/sa1100_generic.c |   13 ----
 drivers/pcmcia/sa1111_generic.c |   12 ----
 drivers/pcmcia/tcic.c           |   12 ----
 drivers/pcmcia/vrc4171_card.c   |   13 ----
 drivers/pcmcia/yenta_socket.c   |   17 +-----
 include/pcmcia/ss.h             |    6 --
 22 files changed, 149 insertions(+), 315 deletions(-)
