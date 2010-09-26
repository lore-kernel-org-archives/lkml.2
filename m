Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0IZODi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:03:38 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:41337 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757682Ab0IZODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:03:36 -0400
Date: Sun, 26 Sep 2010 16:03:26 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA bugfixes for 2.6.36-rc5
Message-ID: <20100926140326.GA859@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

in order to get some more serial devices to work, and to fix an error
path in a socet driver, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

Thanks,
	Dominik

Dominik Brodowski (1):
      pcmcia: preserve configuration information if request_io fails partly

Rahul Ruikar (1):
      pcmcia: pd6729: Fix error path

 drivers/pcmcia/pcmcia_resource.c |    6 ++++++
 drivers/pcmcia/pd6729.c          |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)
