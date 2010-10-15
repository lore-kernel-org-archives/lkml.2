Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0JOIvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:51:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0JOIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:51:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] types.h: define __aligned_u64 and expose to userspace
Date: Fri, 15 Oct 2010 10:51:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        jengelh@medozas.de, davem@davemloft.net, andi@firstfloor.org
References: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101015042455.12772.27482.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151051.05241.arnd@arndb.de>
X-Provags-ID: V02:K0:AvBkQjqMhBygtcrLlXlkdBQbrwI19UI4DL16KzZvZ68
 SOd9imqzNEDqlWq1ansN/n8vLkQeG2Kb4MvR3/hrJNYguh1nGx
 Zt3IEMzuDsqX1mK1EIBwY+MLUIK3ylgzGh9yUiisRUgIXkEzZG
 /K5jf+sZ0+U9Z6Xaj9txYZsQc/Txv9+kymqceWJhCejk5Edb/K
 U1HP0FGHkU/rHUisIZWBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 06:24:55 Eric Paris wrote:
> We currently have a kernel internal type called aligned_u64 which aligns
> __u64's on 8 bytes boundaries even on systems which would normally align
> them on 4 byte boundaries.  This patch creates a new type __aligned_u64
> which does the same thing but which is exposed to userspace rather than
> being kernel internal.
> 
> Based-on-patch-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Eric Paris <eparis@redhat.com>

We should have done this long ago.

Acked-by: Arnd Bergmann <arnd@arndb.de>

BTW, why a define, not a typedef? Probably doesn't really matter in the end,
I just wonder if the define has any advantages here.

	Arnd
