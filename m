Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2HOHvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:51:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2HOHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:51:51 -0400
Date: Wed, 15 Aug 2012 00:51:50 -0700 (PDT)
Message-Id: <20120815.005150.614969789942856064.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120815.004457.1075503861038108671.davem@davemloft.net>
References: <20120815.004457.1075503861038108671.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 15 Aug 2012 00:44:57 -0700 (PDT)

> Please pull to get these two bug fixes.
> 
> Thanks!

Sorry, I botched the original Subject, fixed now.

> The following changes since commit 1a9b4993b70fb1884716902774dc9025b457760d:
> 
>   Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2012-08-01 16:47:15 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master
> 
> for you to fetch changes up to 2856cc2e4d0852c3ddaae9dcb19cb9396512eb08:
> 
>   sparc64: Be less verbose during vmemmap population. (2012-08-15 00:37:29 -0700)
> 
> ----------------------------------------------------------------
> David S. Miller (1):
>       sparc64: Be less verbose during vmemmap population.
> 
> Jiri Kosina (1):
>       sparc64: do not clobber personality flags in sys_sparc64_personality()
> 
>  arch/sparc/kernel/sys_sparc_64.c | 10 +++++-----
>  arch/sparc/mm/init_64.c          | 28 +++++++++++++++++++++++-----
>  2 files changed, 28 insertions(+), 10 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
