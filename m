Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0IOIs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:48:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0IOIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:48:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the nilfs2 tree
Date: Wed, 15 Sep 2010 10:48:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Blunck <jblunck@infradead.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
References: <20100915140114.81406c4f.sfr@canb.auug.org.au>
In-Reply-To: <20100915140114.81406c4f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151048.44071.arnd@arndb.de>
X-Provags-ID: V02:K0:yuAIvxfQRIbilf8sHzM596ApXKb3vBKjBbYKeeKclc1
 h4jYdaWYb9n7y09Szw8oIz9iTgWOkZC+9qULzAKU1QS6Gnus1a
 xnNB/BonBhI23bsfPIsTsNinA+Qq6z5WQujWhJsLiNokQA6yDy
 pbuZa6BarcUlro89A+SmUskbVCBOzfRkURjsiEOF22fbxvpFu1
 dnwXORNdFkDZ9EBHnNBog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010, Stephen Rothwell wrote:
> Today's linux-next merge of the bkl-vfs tree got a conflict in
> fs/nilfs2/super.c between commit 38999dca4fdc4a0d1b92a540bc0772a32b07388a
> ("nilfs2: do not allocate multiple super block instances for a device")
> from the nilfs2 tree and commit 3fec873dc6e9026d98e2359202fa50fd06ee7b64
> ("BKL: Remove BKL from NILFS2") from the bkl-vfs tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Ok, thanks!

> P.S. Arndt, the first of the above bkl/vfs commits does not have a SOB
> line from you and has a bug (missing open brace) that is fixed in the
> second.  Just in case you decide to rebase this branch at any point ...

I'm still rebasing all the branches while people take patches into their
own trees, so I'll fix this up soon. Thanks for the info.

	Arnd
