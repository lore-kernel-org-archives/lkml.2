Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1BOJZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:25:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1BOJZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:25:04 -0500
Date: Tue, 15 Feb 2011 10:25:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] hvcs: fix typo in comment
In-Reply-To: <alpine.LNX.2.00.1102150012390.4530@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102151024550.2160@pobox.suse.cz>
References: <1297724735.1793.34.camel@t41.thuisdomein> <alpine.LNX.2.00.1102150012390.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Jesper Juhl wrote:

> On Tue, 15 Feb 2011, Paul Bolle wrote:
> 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> >  drivers/char/hvcs.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
> > index bedc6c1..af4e650 100644
> > --- a/drivers/tty/hvc/hvcs.c
> > +++ b/drivers/tty/hvc/hvcs.c
> > @@ -292,7 +292,7 @@ struct hvcs_struct {
> >  	/*
> >  	 * Any variable below the kref is valid before a tty is connected and
> >  	 * stays valid after the tty is disconnected.  These shouldn't be
> > -	 * whacked until the koject refcount reaches zero though some entries
> > +	 * whacked until the kobject refcount reaches zero though some entries
> >  	 * may be changed via sysfs initiatives.
> >  	 */
> >  	struct kref kref; /* ref count & hvcs_struct lifetime */
> > 
> 
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
