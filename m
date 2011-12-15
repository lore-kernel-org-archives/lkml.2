Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab1LOXzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:55:41 -0500
Received: from ozlabs.org ([203.10.76.45]:41940 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1LOXzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:55:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool (net & drivers/net)
In-Reply-To: <1323920752.29500.11.camel@joe2Laptop>
References: <877h1ysenl.fsf@rustcorp.com.au> <1323920752.29500.11.camel@joe2Laptop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 16 Dec 2011 09:44:31 +1030
Message-ID: <87k45xqvfs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 19:45:52 -0800, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-12-15 at 13:51 +1030, Rusty Russell wrote:
> > module_param(bool) used to counter-intuitively take an int.  In
> > fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> > trick.
> []
> > diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
> []
> > @@ -38,15 +38,15 @@ MODULE_ALIAS_LDISC(N_CAIF);
> []
> > -static int ser_use_stx = 1;
> > +static bool ser_use_stx = 1;
> 
> Could you respin these please using bool foo = true/false instead?

I could, but as I was touching 457 files, so I was aiming for minimal
changes.

Dave, did you want a true/false cleanup too?

Thanks,
Rusty.
