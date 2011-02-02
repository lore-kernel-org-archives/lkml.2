Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1BBAZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:25:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57028 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1BBAZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:25:23 -0500
Date: Wed, 2 Feb 2011 11:25:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the md-current tree
Message-Id: <20110202112519.7a4d2bd3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

After merging the md-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/md/md.c: In function 'slot_store':
drivers/md/md.c:2466: error: 'mddev' undeclared (first use in this function)

Caused by commit 778f14598b2924e92790ddd8a167424d2894ffb0 ("md: Don't
allow slot_store while resync/recovery is happening").

Please build test your tree before publishing it.

I have used the md-current tree from next-20110201 for today.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
