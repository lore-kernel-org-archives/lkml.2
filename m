Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0DSOPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:15:35 -0400
Received: from isilmar.linta.de ([213.133.102.198]:47429 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753811Ab0DSOPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:15:34 -0400
Date: Mon, 19 Apr 2010 16:12:52 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] PCMCIA patches for 2.6.36-rc5
Message-ID: <20100419141252.GA25320@comet.dominikbrodowski.net>
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

to solve most of the outstanding bugs I'm aware of, I intend to submit a
pull request for a few patches tomorrow. They're available at

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

As usual, I'm interested in your input to this patch series. The individual
patches will be sent out to the PCMCIA list in a few moments.

Best,
	Dominik


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
