Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0F3PY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:24:28 -0400
Received: from kroah.org ([198.145.64.141]:39954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab0F3PY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:24:27 -0400
Date: Wed, 30 Jun 2010 08:23:18 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] serial fix for .35-git
Message-ID: <20100630152318.GA11236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a single bugfix for the cpu_uart serial driver that is for
your .35-git tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

This patch has been in the linux-next tree and -mm tree for a while.

The patch will be sent to the linux-kernel mailing list, if anyone wants
to see it.

thanks,

greg k-h

------------

 drivers/serial/cpm_uart/cpm_uart_core.c |  143 +++++++++++++++++--------------
 1 files changed, 79 insertions(+), 64 deletions(-)

---------------

Dongdong Deng (1):
      serial: cpm_uart: implement the cpm_uart_early_write() function for console poll

