Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2JJEyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:54:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36197 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JJEyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:54:35 -0400
Date: Tue, 9 Oct 2012 21:52:25 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the kmemleak tree with Linus' tree
Message-ID: <20121010045225.GA3975@swordfish>
References: <20121010140644.0235454126ca50b7f60d1f59@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010140644.0235454126ca50b7f60d1f59@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/10/12 14:06), Stephen Rothwell wrote:
> Hi Catalin,
> 
> Today's linux-next merge of the kmemleak tree got a conflict in
> mm/kmemleak.c between commit 85d3a316c714 ("kmemleak: use rbtree instead
> of prio tree") from Linus' tree and commit 48786770bf3b ("kmemleak: do
> not leak object after tree insertion error") from the kmemleak tree.
> 
> The kmemleak tree commit has been there since April, should it have
> progressed by now?  Its fix is also included in the above commit from
> Linus' tree.
> 
> I just used the version from Linus' tree and can carry the fix as
> necessary (no action is required).
> 

Hello,
I can re-base my patch (I thought it's already in Linus' tree).

	-ss
