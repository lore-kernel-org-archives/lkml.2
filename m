Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab2JSLZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2JSLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:25:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121019142147.76f67505862afe5614167428@canb.auug.org.au>
References: <20121019142147.76f67505862afe5614167428@canb.auug.org.au> <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <87fw5bp858.fsf@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
Date: Fri, 19 Oct 2012 12:25:23 +0100
Message-ID: <2201.1350645923@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> So, this still generates the keys during the normal build, right?  That
> would be a problem for build servers that have limited randomness
> available to them, I think.

openssl uses /dev/urandom (unlike gpg), so that's less of a problem.

David
