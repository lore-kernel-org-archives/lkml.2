Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2HNAXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:23:07 -0400
Received: from ozlabs.org ([203.10.76.45]:51556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab2HNAXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:23:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Jonas Gorski <jonas.gorski@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: fix module.c build for 32 bit
In-Reply-To: <31154.1344872382@warthog.procyon.org.uk>
References: <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com> <31154.1344872382@warthog.procyon.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Aug 2012 09:42:31 +0930
Message-ID: <87d32us55c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 16:39:42 +0100, David Howells <dhowells@redhat.com> wrote:
> 
> Hi Rusty,
> 
> I've fixed up my patch for ARM and pulled Jonas's patch on top of that.  Do
> you want me to merge them together?

Yep, thanks.  And might as well sent them straight to Linus; since
linux-next didn't catch this, there's little point baking them there if
we have some acks.

If he misses it, I'll grab them.

Thanks,
Rusty.
