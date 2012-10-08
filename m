Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2JHFZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:25:38 -0400
Received: from ozlabs.org ([203.10.76.45]:53301 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2JHFZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:25:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the modules tree with Linus' tree
In-Reply-To: <20121008114904.8c920933bfdf81a8e0c70647@canb.auug.org.au>
References: <20121008114904.8c920933bfdf81a8e0c70647@canb.auug.org.au>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 08 Oct 2012 13:11:18 +1030
Message-ID: <87vcelptwx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> Today's linux-next merge of the modules tree got a conflict in
> init/Kconfig between commit 754b7b63d112 ("sections: disable const
> sections for PA-RISC v2") from Linus' tree and commit 54ddd23d78ba
> ("X.509: Add simple ASN.1 grammar compiler") from the modules tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> BTW, Rusty, that commit from the modules tree has no SOB from you even
> though you committed it.

Well, I merged that whole branch actually.

>From now on I'll be cherry-picking instead (mainly because I want to
fold in fixes anyway, and that's a bit messy).

Cheers,
Rusty.
