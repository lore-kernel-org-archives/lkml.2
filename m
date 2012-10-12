Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab2JLPWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:22:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47061 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab2JLPWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:22:14 -0400
Date: Fri, 12 Oct 2012 16:22:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the kmemleak tree with Linus' tree
Message-ID: <20121012152205.GA13957@arm.com>
References: <20121010140644.0235454126ca50b7f60d1f59@canb.auug.org.au>
 <20121010045553.GB3975@swordfish>
MIME-Version: 1.0
In-Reply-To: <20121010045553.GB3975@swordfish>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Oct 2012 15:22:10.0743 (UTC) FILETIME=[59679C70:01CDA88D]
X-MC-Unique: 112101216221201301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 05:55:53AM +0100, Sergey Senozhatsky wrote:
> On (10/10/12 14:06), Stephen Rothwell wrote:
> > Today's linux-next merge of the kmemleak tree got a conflict in
> > mm/kmemleak.c between commit 85d3a316c714 ("kmemleak: use rbtree instead
> > of prio tree") from Linus' tree and commit 48786770bf3b ("kmemleak: do
> > not leak object after tree insertion error") from the kmemleak tree.
> > 
> > The kmemleak tree commit has been there since April, should it have
> > progressed by now?  Its fix is also included in the above commit from
> > Linus' tree.
> > 
> > I just used the version from Linus' tree and can carry the fix as
> > necessary (no action is required).
> 
> Oh, my bad! Just took a look on current create_object(). I guess we can
> drop my patch.

Sorry, I haven't pushed it early enough and I've seen the rbtree
conversion patch in the meantime which was fixing this as well.

I've updated my kmemleak branch now. Stephen, I guess you can remove
this branch since I don't have any outstanding kmemleak patches.

Thanks.

-- 
Catalin

