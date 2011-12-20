Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1LTXcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:32:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1LTXca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:32:30 -0500
Date: Wed, 21 Dec 2011 00:32:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] devres: Fix a typo in devm_kfree comment
In-Reply-To: <20111220154748.GB10752@google.com>
Message-ID: <alpine.LNX.2.00.1112210032040.8727@pobox.suse.cz>
References: <1324365465.9836.1.camel@phoenix> <20111220154748.GB10752@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Tejun Heo wrote:

> (cc'ing Jiri, hi!)

Hi Tejun, thanks for CCing me.

> On Tue, Dec 20, 2011 at 03:17:45PM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/base/devres.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> > index 65cd748..524bf96 100644
> > --- a/drivers/base/devres.c
> > +++ b/drivers/base/devres.c
> > @@ -639,7 +639,7 @@ EXPORT_SYMBOL_GPL(devm_kzalloc);
> >   * @dev: Device this memory belongs to
> >   * @p: Memory to free
> >   *
> > - * Free memory allocated with dev_kzalloc().
> > + * Free memory allocated with devm_kzalloc().
> >   */
> >  void devm_kfree(struct device *dev, void *p)
> >  {
> > -- 
> > 1.7.5.4
> 
> Yeap, looks good to me.  Jiri, can you please route this through the
> trivial tree?  The original message can be read from
> 
>  http://article.gmane.org/gmane.linux.kernel/1231296/raw  
> 
> Thanks a lot.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
