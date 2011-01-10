Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1AJF6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:58:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:33034 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1AJF6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:58:52 -0500
Date: Mon, 10 Jan 2011 14:58:23 +0900 (JST)
Message-Id: <20110110.145823.220041803.ryusuke@osrg.net>
To: sfr@canb.auug.org.au
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk
Subject: Re: linux-next: manual merge of the nilfs2 tree with the tree
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20110110120746.7cd287b0.sfr@canb.auug.org.au>
References: <20110110120746.7cd287b0.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 Jan 2011 14:58:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 12:07:46 +1100, Stephen Rothwell wrote:
> Hi Ryusuke,
> 
> Today's linux-next merge of the nilfs2 tree got a conflict in
> fs/nilfs2/nilfs.h between commit b74c79e99389cd79b31fcc08f82c24e492e63c7e
> ("fs: provide rcu-walk aware permission i_ops") from Linus' tree and
> commit aa9ded135baf342ec5a299b254f0e0dbd5c3c0f0 ("nilfs2: do not pass sbi
> to functions which can get it from inode") from the nilfs2 tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks Stephen.  The fix looks good to me.

I'll apply it soon and resolve the conflict.

Ryusuke Konishi
