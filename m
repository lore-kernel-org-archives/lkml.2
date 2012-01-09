Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2AIHMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:12:38 -0500
Received: from ozlabs.org ([203.10.76.45]:42720 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2AIHMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:12:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool (drivers & misc)
In-Reply-To: <CAMuHMdVYhVnxuvhThpeqcaazkSJQJBtrwrxwJc0=y_hV_7PsNg@mail.gmail.com>
References: <87ehw6sesk.fsf@rustcorp.com.au> <CAMuHMdVYhVnxuvhThpeqcaazkSJQJBtrwrxwJc0=y_hV_7PsNg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jan 2012 16:56:36 +1030
Message-ID: <87ehv99ysj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 13:31:40 +0100, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Rusty,
> 
> On Thu, Dec 15, 2011 at 04:18, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > diff --git a/drivers/block/paride/bpck6.c b/drivers/block/paride/bpck6.c
> > --- a/drivers/block/paride/bpck6.c
> > +++ b/drivers/block/paride/bpck6.c
> > @@ -21,7 +21,7 @@
> >
> >
> >  /* PARAMETERS */
> > -static int verbose; /* set this to 1 to see debugging messages and whatnot */
> > +static bool verbose; /* set this to 1 to see debugging messages and whatnot */
> 
> "bool" doesn't exist at this point, cfr.
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/5325550/
> http://kisskb.ellerman.id.au/kisskb/buildresult/5325257/
> 
> Any chance this is going to be fixed before it's sucked in Linus'
> tree?

Of course, done (moved declaration and comment below #includes).

Thanks!
Rusty.
