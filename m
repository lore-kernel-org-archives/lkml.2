Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2JJSzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:55:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60491 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2JJSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:55:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 10 Oct 2012 20:55:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20121010205538.1d47248c@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fix" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix

to get an old bug of the /dev/fw* ioctl ABI fixed.  Thanks.

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)

 drivers/firewire/core-cdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
-- 
Stefan Richter
-=====-===-- =-=- -=-=-
http://arcgraph.de/sr/
