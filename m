Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2DINax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:30:53 -0400
Received: from 1wt.eu ([62.212.114.60]:64963 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab2DINaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:30:52 -0400
Date: Mon, 9 Apr 2012 15:30:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org
Subject: No more Linux 2.4 releases
Message-ID: <20120409133050.GA17473@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

15 months ago I announced that if no more critical fix was to be merged
by one year, 2.4 would be EOLed after a year (around december 2011). The
break-in of last year made things a bit difficult for some users but
nothing really important for 2.4 users was merged since, so the EOL had
no reason to be delayed.

However since the break-in, I was surprized to see that some users have
asked where to find the 2.4 git tree to pick some fixes from it. After
discussing with several of them, it appears that they're not really
interested in releases, rather just in having a place where fixes are
centralized and that the git tree is perfect for this. So I revived the
git tree in my account and will probably push a patch there once in a
while if people ask for this, but with no guarantees.

Anyway I don't intend to waste any more space on kernel.org with tar.gz
files nor patches that too few people use.

The repository is now available here :

   http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git

If anyone has any question, feel free to ask.

Willy

