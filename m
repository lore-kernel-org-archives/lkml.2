Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0GTPYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab0GTPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:24:21 -0400
Date: Tue, 20 Jul 2010 17:24:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Infinipath <Infinipath@qlogic.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of
 private_data
In-Reply-To: <1279046497.2296.170.camel@chromite.mv.qlogic.com>
Message-ID: <alpine.LNX.2.00.1007201724010.4741@pobox.suse.cz>
References: <cover.1278967120.git.joe@perches.com>  <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com> <1279046497.2296.170.camel@chromite.mv.qlogic.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Ralph Campbell wrote:

> Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>
> 
> On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > index 9c5c66d..65eb892 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > @@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
> >  
> >  	mutex_lock(&ipath_mutex);
> >  
> > -	fd = (struct ipath_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  	fp->private_data = NULL;
> >  	pd = fd->pd;
> >  	if (!pd) {

As the patch is not present in linux-next as of today, I have applied it. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
