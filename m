Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2JXL37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:29:59 -0400
Received: from ozlabs.org ([203.10.76.45]:37042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab2JXL3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:29:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the modules tree with the  tree
In-Reply-To: <20121022123553.240d9ddf05cd5e2c8fee0ab3@canb.auug.org.au>
References: <20121022123553.240d9ddf05cd5e2c8fee0ab3@canb.auug.org.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 24 Oct 2012 10:51:49 +1030
Message-ID: <87vce0oh2a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Rusty,
>
> Today's linux-next merge of the modules tree got a conflict in
> kernel/module.c between commit caabe240574a ("MODSIGN: Move the magic
> string to the end of a module and eliminate the search") from Linus' tree
> and commit 0250abdeec54 ("module: add syscall to load module from fd")
> from the modules tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>
> I do wonder why the above change in Linus' tree seems to have bypassed
> the modules maintainer.

Yes.  David tacked it on to a real bugfix which went straight to Linus;
having fixed my mess I couldn't complain too much (though I had NAKed
similar patches in the past).

I will rebase my -next tree today.

Cheers,
Rusty.
