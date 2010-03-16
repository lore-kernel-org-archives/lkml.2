Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937985Ab0CPSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:16:57 -0400
Received: from isilmar.linta.de ([213.133.102.198]:36868 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756636Ab0CPSQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:16:55 -0400
Date: Tue, 16 Mar 2010 19:16:47 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.34-rc2
Message-ID: <20100316181647.GA3464@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

some PCMCIA bugfixes for 2.6.34-rc2 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Please pull from that location. The diffstat and list of changes follows,
the individual diffs were sent (at least) to the linux-pcmcia list.

Thanks,
	Dominik

----

Dan Carpenter (1):
      pcmcia: add important if statement

Dominik Brodowski (2):
      pcmcia: pd6729, i82092: use parent (PCI) resources
      pcmcia: revert "irq probe can be done without risking an IRQ storm"

Jens Künzer (3):
      pcmcia: honor saved flags in yenta_socket's I365_CSCINT register
      pcmcia: allow for cb_irq to differ from pci_dev's irq in yenta_socket
      pcmcia: re-route Cardbus IRQ to ISA on ti1130 bridges if necessary

Jiri Slaby (1):
      PCMCIA: resource, fix lock imbalance

Yoichi Yuasa (1):
      pcmcia/vrc4171: use local spinlock for device local lock.

 drivers/pcmcia/i82092.c          |    1 +
 drivers/pcmcia/i82365.h          |    1 +
 drivers/pcmcia/pcmcia_resource.c |   36 +++++++++++++----------------
 drivers/pcmcia/pd6729.c          |    1 +
 drivers/pcmcia/ti113x.h          |   37 ++++++++++++++++++++++++++++-
 drivers/pcmcia/vrc4171_card.c    |    5 ++-
 drivers/pcmcia/yenta_socket.c    |   46 +++++++++++++++++++++++--------------
 drivers/scsi/pcmcia/nsp_cs.c     |    1 +
 8 files changed, 86 insertions(+), 42 deletions(-)
