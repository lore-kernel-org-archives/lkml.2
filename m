Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2J2DCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:02:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45187 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2J2DCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:02:53 -0400
Date: Sun, 28 Oct 2012 23:02:48 -0400 (EDT)
Message-Id: <20121028.230248.474896018222179374.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: viro@ZenIV.linux.org.uk, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the signal tree with the sparc tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121029140032.4019da59dbc50a9be8df9ebc@canb.auug.org.au>
References: <20121029140032.4019da59dbc50a9be8df9ebc@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Oct 2012 14:00:32 +1100

> Today's linux-next merge of the signal tree got a conflict in
> arch/sparc/kernel/sys_sparc_64.c between commit 517ffce4e1a0 ("sparc64:
> Make montmul/montsqr/mpmul usable in 32-bit threads") from the sparc tree
> and commit 2f12af35a988 ("sparc64: switch to generic kernel_execve()")
> from the signal tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I intend to pull the sparc tree into sparc-next, then pull the sparc
branch from Al's tree into sparc-next to fix this up.
