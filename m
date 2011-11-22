Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1KVA7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:59:37 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38978 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab1KVA7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:35 -0500
X-Sasl-enc: iTH1XuxSveR8Oa5qxjOHqrwIHtO467C/y8fm/T9PehOs 1321923574
Date: Mon, 21 Nov 2011 16:58:58 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 3.2
Message-ID: <20111122005858.GB25420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some small driver core fixes for your 3.2 tree.

Nothing major here, all is explained below in the shortlog.

Please pull from:
	git.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-linus

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
 drivers/base/node.c                  |   14 ++++++++------
 include/linux/device.h               |    2 +-
 3 files changed, 15 insertions(+), 8 deletions(-)

---------------

Claudio Scordino (1):
      drivers/base/node.c: fix compilation error with older versions of gcc

Geoff Thorpe (1):
      uio: documentation fixups

Marcos Paulo de Souza (1):
      device.h: Fix struct member documentation

