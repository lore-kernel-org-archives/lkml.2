Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1FVAMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:12:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40301 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab1FVAMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:12:42 -0400
X-Sasl-enc: oPxIJQoq5eQwme+LtoO09MYsUAu8GELnuXx4VOB5b0K1 1308701560
Date: Tue, 21 Jun 2011 17:10:09 -0700
From: Greg KH <greg@kroah.com>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the trivial
 and net trees
Message-ID: <20110622001009.GA9627@kroah.com>
References: <20110621151055.0775f17a.sfr@canb.auug.org.au>
 <BANLkTimmy0GJMgho4YK62gru6QXGox6Eqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimmy0GJMgho4YK62gru6QXGox6Eqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 01:40:48AM +0300, Vitaliy Ivanov wrote:
> Stephen,
> 
> On Tue, Jun 21, 2011 at 8:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/brcm80211/brcmfmac/wl_iw.c between commit e44ba033c565
> > ("treewide: remove duplicate includes") from the trivial tree, commit
> > 219eb47e6f35 ("net/staging: add needed interrupt.h and hardirq.h
> > includes") from the net tree and various commits from the staging tree.
> >
> > I fixed them up (see below) and can carry the fix as necessary.
> 
> This one and all the others look good to me.

Me too, thanks for doing this.

greg k-h
