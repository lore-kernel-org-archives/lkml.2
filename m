Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2IUP5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:57:02 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46227 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2IUP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:00 -0400
Date: Fri, 21 Sep 2012 11:45:51 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marcus Karlsson <mk@acc.umu.se>, gregkh@linuxfoundation.org,
        xiaoguangrong@linux.vnet.ibm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix spelling of comment
Message-ID: <20120921154550.GB4780@phenom.dumpdata.com>
References: <1346531386-9524-1-git-send-email-mk@acc.umu.se>
 <20120905160555.GA12339@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905160555.GA12339@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:05:55PM -0400, Konrad Rzeszutek Wilk wrote:
> On Sat, Sep 01, 2012 at 10:29:46PM +0200, Marcus Karlsson wrote:
> > Fix spelling in tmem.c:
> > Transcedent -> Transcendent
> > 
> > Signed-off-by: Marcus Karlsson <mk@acc.umu.se>
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Greg, can you pick this up for 3.7 pls? Or should I prep a git branch
to send to you (I've a patch for the TODO file as well).

> > ---
> >  drivers/staging/zcache/tmem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
> > index eaa9021..56c8e60 100644
> > --- a/drivers/staging/zcache/tmem.c
> > +++ b/drivers/staging/zcache/tmem.c
> > @@ -3,7 +3,7 @@
> >   *
> >   * Copyright (c) 2009-2011, Dan Magenheimer, Oracle Corp.
> >   *
> > - * The primary purpose of Transcedent Memory ("tmem") is to map object-oriented
> > + * The primary purpose of Transcendent Memory ("tmem") is to map object-oriented
> >   * "handles" (triples containing a pool id, and object id, and an index), to
> >   * pages in a page-accessible memory (PAM).  Tmem references the PAM pages via
> >   * an abstract "pampd" (PAM page-descriptor), which can be operated on by a
> > -- 
> > 1.7.12
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
