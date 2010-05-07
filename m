Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0EGHoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:44:21 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:58342 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079Ab0EGHoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:44:19 -0400
Date: Fri, 7 May 2010 09:44:11 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] more PCMCIA bugfixes for 2.6.34-rc6
Message-ID: <20100507074411.GA21715@comet.dominikbrodowski.net>
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

a few more bugfixes are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Please pull from this location. The diffstat and list of changes follows.

Thanks,
	Dominik

----

Dominik Brodowski (2):
      pcmcia: avoid pccard_validate_cis failure in resume callpath
      pcmcia: order userspace suspend and resume requests

Marc Zyngier (1):
      pcmcia: fix compilation after 16bit state locking changes

 drivers/pcmcia/cs.c           |   16 +++++++++-------
 drivers/pcmcia/ds.c           |    1 +
 drivers/pcmcia/pcmcia_ioctl.c |    7 +------
 3 files changed, 11 insertions(+), 13 deletions(-)
