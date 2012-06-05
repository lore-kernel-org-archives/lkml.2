Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2FEAVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:21:08 -0400
Received: from ozlabs.org ([203.10.76.45]:36245 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761255Ab2FEAUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:20:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: init: multi param parsing regression since 3.4
In-Reply-To: <CA+55aFwJj5t6zS_pgD3kMemRWkUkSoWWHey84pJegSRfnzXNzA@mail.gmail.com>
References: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com> <87ipf71ytx.fsf@rustcorp.com.au> <CA+55aFwJj5t6zS_pgD3kMemRWkUkSoWWHey84pJegSRfnzXNzA@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 05 Jun 2012 09:47:49 +0930
Message-ID: <878vg2k3wy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012 13:39:27 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sun, Jun 3, 2012 at 9:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Subject: module_param: stop double-calling parameters.
> > From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Rusy, should I take this (with the ubi/build.c part removed) from the
> email - along with the initcall debug printk removals - or can I just
> expect to get a pull request with these things?
> 
>                 Linus

I like to spin this stuff for a day through linux-next, which should be
happening right now.

But if you want to save me the trouble of a pull request, sure.

Thanks,
Rusty.
