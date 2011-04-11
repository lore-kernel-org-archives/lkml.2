Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1DKRro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:47:44 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48338 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1DKRrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:47:43 -0400
Date: Mon, 11 Apr 2011 19:47:37 +0200
From: Florian Mickler <florian@mickler.org>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] Remove non-MAINTAINERS email address references for
 Lennert Buytenhek.
Message-ID: <20110411194737.1d75e053@schatten.dmk.lab>
In-Reply-To: <20110410202716.GK22881@wantstofly.org>
References: <20110410134504.GG22881@wantstofly.org>
	<20110410.132002.193717670.davem@davemloft.net>
	<20110410202716.GK22881@wantstofly.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011 22:27:16 +0200
Lennert Buytenhek <buytenh@wantstofly.org> wrote:

> On Sun, Apr 10, 2011 at 01:20:02PM -0700, David Miller wrote:
> 
> > > This gets rid of all (obsolete as well as still valid) email addresses
> > > for Lennert Buytenhek across the tree -- MAINTAINERS should be used for
> > > obtaining a valid email address.
> > > 
> > > Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> > 
> > Lennert, this is silly.
> > 
> > That email address acts as part of the identification of who you
> > are, and is part of the copyright.
> 
> The problem is that half of them are out of date.  I at first sent a
> patch to change them all over to buytenh@wantstofly.org, but then got:
> 
> 	http://marc.info/?l=linux-kernel&m=129858453409012&w=2
> 
> which seemed sensible. :-/

What about the .mailmap file in the kernel source tree? ( man
git-shortlog )

That is honoured at least by git and scripts/get_maintainers.pl ...

You'll want to add lines of the form:
Lennert Buytenhek <buytenh@wantstofly.org> Lennert Buytenhek <old address>

I guess...

Regards,
Flo
