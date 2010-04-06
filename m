Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0DFTug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:50:36 -0400
Received: from isilmar.linta.de ([213.133.102.198]:44710 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187Ab0DFTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:50:30 -0400
Date: Tue, 6 Apr 2010 21:50:23 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfix for 2.6.34-rc3
Message-ID: <20100406195023.GA7068@comet.dominikbrodowski.net>
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

one important PCMCIA bugfix for 2.6.34-rc4 is available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Please pull from that location. The diffstat and list of changes follows.

Thanks,
	Dominik

----

Dominik Brodowski (1):
      pcmcia: fix up alignf issues

 drivers/pcmcia/rsrc_nonstatic.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)
