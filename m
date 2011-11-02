Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1KBSQa (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 2 Nov 2011 14:16:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41352 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1KBSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:16:29 -0400
Date: Wed, 2 Nov 2011 14:09:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: wireless git trees returning to kernel.org
Message-ID: <20111102180946.GC12168@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI...

I have migrated the wireless git trees back to the kernel.org
infrastructure.  As of right now, the trees are identical between
kernel.org and infradead.org.  Further updates likely will only go
to kernel.org, so plan accordingly.

The "current" wireless tree is here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git

The "next" wireless tree is here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git

The "testing" wireless tree is here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

Please do the needful!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
