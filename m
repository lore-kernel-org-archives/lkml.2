Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab0D1GLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:11:40 -0400
Received: from isilmar.linta.de ([213.133.102.198]:44919 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803Ab0D1GLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:11:38 -0400
Date: Wed, 28 Apr 2010 08:11:30 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfixes for 2.6.34-rc6
Message-ID: <20100428061130.GA4497@comet.dominikbrodowski.net>
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

in order to solve bugzilla bug 13426, and to fix another bug Alexander Kurz
tracked down, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patches went to the PCMCIA
list yesterday.

Thanks,
	Dominik

----

Alexander Kurz (1):
      pcmcia: fix matching rules for pseudo-multi-function cards

Dominik Brodowski (1):
      pcmcia: pcmcia_dev_present bugfix

 drivers/pcmcia/ds.c |   54 +++++++++++++++++----------------------------------
 include/pcmcia/ds.h |    7 ++---
 include/pcmcia/ss.h |    8 ++----
 3 files changed, 24 insertions(+), 45 deletions(-)
