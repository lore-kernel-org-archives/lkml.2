Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0GEMcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:32:31 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:54541 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237Ab0GEMca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:32:30 -0400
Date: Mon, 5 Jul 2010 14:31:20 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfix for 2.6.35-rc4
Message-ID: <20100705123119.GA7128@comet.dominikbrodowski.net>
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

in order to solve one remaining PCMCIA bug, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

The diffstat and list of changes follows; the patch is sent to the PCMCIA
list.

Thanks,
	Dominik

----

Dominik Brodowski (1):
      pcmcia: do not initialize the present flag too late.

 drivers/pcmcia/ds.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
