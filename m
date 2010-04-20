Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0DTLzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:55:07 -0400
Received: from isilmar.linta.de ([213.133.102.198]:49849 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753572Ab0DTLzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:55:05 -0400
Date: Tue, 20 Apr 2010 13:54:09 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.34-rc6
Message-ID: <20100420115409.GA30097@comet.dominikbrodowski.net>
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

to solve most of the outstanding PCMCIA bugs I'm aware of -- notable
exception is the regression in kernel bugzilla 13426 --, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patches went to the PCMCIA
list yesterday.

Thanks,
	Dominik

----

Dan Carpenter (1):
      pcmcia: fix error handling in cm4000_cs.c

Dominik Brodowski (5):
      pcmcia: use previously assigned IRQ for all card functions
      pcmcia: fix io_probe due to parent (PCI) resources
      pcmcia: re-start on MFC override
      pcmcia: fix ioport size calculation in rsrc_nonstatic
      pcmcia: avoid late calls to pccard_validate_cis

Julia Lawall (1):
      drivers/pcmcia: Add missing local_irq_restore

Timur Maximov (1):
      serial_cs: MD55x support (PCMCIA GPRS/EDGE modem) (kernel 2.6.33)

 drivers/char/pcmcia/cm4000_cs.c  |    8 +++++---
 drivers/pcmcia/cistpl.c          |    9 +++++++--
 drivers/pcmcia/db1xxx_ss.c       |    4 +++-
 drivers/pcmcia/ds.c              |   22 ++++++++++++++--------
 drivers/pcmcia/pcmcia_resource.c |   10 +++++-----
 drivers/pcmcia/rsrc_nonstatic.c  |   16 ++++++++++++----
 drivers/serial/serial_cs.c       |    9 +++++++++
 7 files changed, 55 insertions(+), 23 deletions(-)
