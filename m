Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0IOQaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:30:09 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:36625 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753577Ab0IOQaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:30:07 -0400
Date: Wed, 15 Sep 2010 18:25:03 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [RFC] PCMCIA patches for 2.6.36-rc5
Message-ID: <20100915162503.GA15043@comet.dominikbrodowski.net>
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

in order to solve a severe bug rendering many serial PCMCIA cards
unuseable, and to let pcnet_cs work on more cards, I intend to submit
a pull request for three patches tomorrow. They're available at

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

As usual, I'm interested in your input to this patch series. The individual
patches will be sent out (at least) to the PCMCIA list in a few moments.

Best,
	Dominik

Dominik Brodowski (3):
      pcmcia serial_cs.c: fix multifunction card handling
      pcmcia: per-device, not per-socket debug messages
      pcmcia pcnet_cs: try setting io_lines to 16 if card setup fails

 drivers/net/pcmcia/pcnet_cs.c    |  139 ++++++++++++++++++++++---------------
 drivers/pcmcia/pcmcia_resource.c |   51 +++++++-------
 drivers/serial/serial_cs.c       |   62 ++++++++++-------
 3 files changed, 146 insertions(+), 106 deletions(-)
