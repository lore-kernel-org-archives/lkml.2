Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0D0RBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:01:33 -0400
Received: from isilmar.linta.de ([213.133.102.198]:56413 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752219Ab0D0RBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:01:31 -0400
Date: Tue, 27 Apr 2010 18:59:51 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] PCMCIA patches for 2.6.34-rc5 -- 2nd batch
Message-ID: <20100427165951.GA9276@comet.dominikbrodowski.net>
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

in order to solve bugzilla bug 13426, and to fix another bug Alexander Kurz
tracked down, I intend to submit a pull request for two additional
patches tomorrow. They're available at

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

As usual, I'm interested in your input to this patch series. The individual
patches will be sent out to the PCMCIA list in a few moments.

Best,
	Dominik

Alexander Kurz (1):
      pcmcia: fix matching rules for pseudo-multi-function cards

Dominik Brodowski (1):
      pcmcia: pcmcia_dev_present bugfix

 drivers/pcmcia/ds.c |   54 +++++++++++++++++----------------------------------
 include/pcmcia/ds.h |    7 ++---
 include/pcmcia/ss.h |    8 ++----
 3 files changed, 24 insertions(+), 45 deletions(-)
