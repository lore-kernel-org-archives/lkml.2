Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2JARyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:54:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52736 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab2JARyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:54:35 -0400
X-Sasl-enc: gptXsg7ruFonCr0C9EGGzt2OUBeDWUY//iR1poqkFHNZ 1349114074
Date: Mon, 1 Oct 2012 10:54:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc changes for 3.7-rc1
Message-ID: <20121001175433.GA10092@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.6

for you to fetch changes up to fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

----------------------------------------------------------------
char/misc driver merge for 3.7-rc1

Here is the "big" char/misc driver tree update for the 3.7-rc1 merge
window.

Nothing major, just a number of driver updates and fixes, all of which
have been in the linux-next releases for a while now either in my tree,
or in Andrew's (the lis3l driver changes came from his tree last week).

----------------------------------------------------------------
