Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1JCTfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:35:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46398 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1JCTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:35:13 -0400
Date: Mon, 03 Oct 2011 15:35:09 -0400 (EDT)
Message-Id: <20111003.153509.1840897953839267838.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 03 Oct 2011 12:35:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this request leak fix from Borislav Petkov.

Thanks!

The following changes since commit 9b13776977d45505469edc6decc93e9e3799afe2:

  Merge branch 'for-linus' of git://git.infradead.org/users/sameo/mfd-2.6 (2011-10-02 19:23:44 -0700)

are available in the git repository at:

  git://github.com/davem330/ide.git master

Borislav Petkov (1):
      ide-disk: Fix request requeuing

 drivers/ide/ide-disk.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)
