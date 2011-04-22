Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab1DVXHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:07:23 -0400
Received: from kroah.org ([198.145.64.141]:46555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1DVXHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:07:21 -0400
Date: Fri, 22 Apr 2011 16:07:13 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver fixes for .39
Message-ID: <20110422230713.GA5883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some small tty/serial fixes for the .39 tree.

It also includes a parport patch, as it seems relevant to the serial
drivers (resource conflict) and there's not a parport maintainer tree
anywhere that I know of.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these patches have been in the -mm and -next trees for a while.

Patches will be sent to the linux-serial mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/parport/parport_pc.c |    8 +++-----
 drivers/tty/n_gsm.c          |    8 ++++++--
 drivers/tty/serial/imx.c     |    3 ++-
 3 files changed, 11 insertions(+), 8 deletions(-)

---------------

Mikhail Kshevetskiy (1):
      tty/n_gsm: fix bug in CRC calculation for gsm1 mode

Niels de Vos (1):
      parport_pc.c: correctly release the requested region for the IT887x

Uwe Kleine-König (1):
      serial/imx: read cts state only after acking cts change irq

