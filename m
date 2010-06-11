Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403Ab0FKOpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:45:25 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:33968 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760287Ab0FKOpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:45:24 -0400
Date: Fri, 11 Jun 2010 16:43:59 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.35-rc3
Message-ID: <20100611144359.GA9572@comet.dominikbrodowski.net>
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

in order to solve a few bugs -- among them most probably bug 16138, even
though the bug reporter hasn't verified the bugfix so far -- please pull
from

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patches are sent to the PCMCIA
list.

Thanks,
	Dominik

----

Dominik Brodowski (3):
      pcmcia: only keep saved I365_CSCINT flag if there is no PCI irq
      pcmcia: dev_node removal bugfix
      pcmcia: avoid validate_cis failure on CIS override

Justin P. Mattock (1):
      pcmcia: yenta_socket.c Remove extra #ifdef CONFIG_YENTA_TI

 drivers/net/pcmcia/smc91c92_cs.c |    1 +
 drivers/pcmcia/ds.c              |    1 +
 drivers/pcmcia/yenta_socket.c    |   19 +++++++++----------
 3 files changed, 11 insertions(+), 10 deletions(-)
