Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1GQVp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:45:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1GQVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:45:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Sun, 17 Jul 2011 23:44:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
References: <20110716150741.a2ed85a4f7addcfccedf16e7@canb.auug.org.au>
In-Reply-To: <20110716150741.a2ed85a4f7addcfccedf16e7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107172344.35422.arnd@arndb.de>
X-Provags-ID: V02:K0:Wr444hjyInVw/A8JF+ICkrEnR18o4rk1KfCn5xapUui
 rTxgyrGm6jqseUNzZDNN9HCH31VG1hdV6nkKoFT8zBoRtqrCNu
 ch7E1sTvZywSGSbxJFzWq9RTIYDfOjPQvG+ZMaHafIlkkfx+Xt
 I8kSSdj4Lx+YXDwUU/55h/W9nxT3BwHrmSD8+23wg/lmkZHlJ7
 jWq//kx2/jjqqLXwG1JmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 July 2011 07:07:41 Stephen Rothwell wrote:
> Hi Arnd,
> 
> Today's linux-next merge of the arm-soc tree got conflicts in lots of
> files due to commit 7712eeac230b ("arm-soc: remove rmk/for-next merge")
> from the arm-soc tree (and maybe some others).
> 
> Arnd, is there some way that you can rebuild (rebase) your tree without
> the merge of Russell's tree and the consequent revert of that merge?  It
> is likely to revert a whole swath of changes from Russell's tree :-(
> 
> I have dropped the arm-soc tree for today.

I've done a new branch 'for-next' now to replace the 'master' branch, and
it does not contain the broken merge any more. Please change your list
of branches accordingly.

There are three other conflicts that I found when test-merging the arm-soc
tree with the current linux-next tree. I've already written about the
omap_dss2 mismerge, which is a huge mess and I've resolved that conflict
on my end for now. There is a simpler conflict with the gpio tree, which
I've also resolved in a similar way by adding a dependency here.

The third conflict in arch/arm/mach-imx/mach-mx27_3ds.c is much simpler, so
I assume you will do the obvious hand-merge.

Thanks,

	Arnd
