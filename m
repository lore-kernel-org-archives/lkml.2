Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2JIRNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:13:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38995 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2JIRM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:12:58 -0400
Date: Tue, 09 Oct 2012 13:12:56 -0400 (EDT)
Message-Id: <20121009.131256.607485133133230904.davem@davemloft.net>
To: dhowells@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for sparc [ver #2]
From: David Miller <davem@davemloft.net>
In-Reply-To: <21204.1349774160@warthog.procyon.org.uk>
References: <21204.1349774160@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 09 Oct 2012 10:16:00 +0100

> Can you merge the following branch into the sparc tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
> 
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-sparc-20121009
> 
> for you to fetch changes up to 5457982641fb3f5fb08ce22a853dd5474645c66d:
> 
>   UAPI: (Scripted) Disintegrate arch/sparc/include/asm (2012-10-09 09:47:43 +0100)

Pulled, thanks David.
