Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab2EPEAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 00:00:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2EPEAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 00:00:45 -0400
Date: Tue, 15 May 2012 23:57:47 -0400 (EDT)
Message-Id: <20120515.235747.716576574995746023.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mmarek@suse.cz, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: linux-next: manual merge of the kbuild tree with the
 sparc-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120516134430.14f8e43c6f75604410dae815@canb.auug.org.au>
References: <20120516134430.14f8e43c6f75604410dae815@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 20:57:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 May 2012 13:44:30 +1000

> Today's linux-next merge of the kbuild tree got a conflict in
> arch/sparc/boot/Makefile between commit 51f19cfa76d7 ("sparc32: drop
> build time btfixup patching") from the sparc-next tree and commit
> 95698570510b ("kbuild: refactor final link of sparc32") from the kbuild
> tree.
> 
> I have no idea, so I used the version from the sparc-next tree.
> 
> Sam, can you have a look and work this out, please?

As Sam states in:

http://patchwork.ozlabs.org/patch/159094/

	This patch will conflict badly with a patch in kbuild-next.

	The fix is simple - drop all changes from kbuild-next.

:-)
