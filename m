Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab0IOETY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:19:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:41472 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IOETX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:19:23 -0400
Date: Wed, 15 Sep 2010 13:16:28 +0900 (JST)
Message-Id: <20100915.131628.69479307.ryusuke@osrg.net>
To: sfr@canb.auug.org.au
Cc: arnd@arndb.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        jblunck@infradead.org, konishi.ryusuke@lab.ntt.co.jp
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the nilfs2
 tree
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100915140114.81406c4f.sfr@canb.auug.org.au>
References: <20100915140114.81406c4f.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 15 Sep 2010 13:16:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 14:01:14 +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> Today's linux-next merge of the bkl-vfs tree got a conflict in
> fs/nilfs2/super.c between commit 38999dca4fdc4a0d1b92a540bc0772a32b07388a
> ("nilfs2: do not allocate multiple super block instances for a device")
> from the nilfs2 tree and commit 3fec873dc6e9026d98e2359202fa50fd06ee7b64
> ("BKL: Remove BKL from NILFS2") from the bkl-vfs tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

The fix looks fine to me.

Thanks!

Ryusuke Konishi
