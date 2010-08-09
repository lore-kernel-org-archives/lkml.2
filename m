Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0HIOpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:45:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48651 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab0HIOpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:45:22 -0400
Date: Mon, 9 Aug 2010 16:45:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Dan Carpenter <error27@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] scsi: mpt2sas: Add space in printk
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
Message-ID: <Pine.LNX.4.64.1008091644280.28909@ask.diku.dk>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk> <20100806075914.GS9031@bicker>
 <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010, Desai, Kashyap wrote:

> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:error27@gmail.com]
> > Sent: Friday, August 06, 2010 1:29 PM
> > To: Julia Lawall
> > Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moore, Eric;
> > Desai, Kashyap
> > Subject: [PATCH] scsi: mpt2sas: Add space in printk
> > 
> > Add a space in the output:
> > old:  Discovery: (stop)discovery_status(0x%08x)
> > new:  Discovery: (stop) discovery_status(0x%08x)
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> > This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
> > confusing if indentation
> > 
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > index 12faf64..562b909 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > @@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER
> > *ioc,
> >  		    (event_data->ReasonCode ==
> > MPI2_EVENT_SAS_DISC_RC_STARTED) ?
> >  		    "start" : "stop");
> >  		if (event_data->DiscoveryStatus)
> > -			printk("discovery_status(0x%08x)",
> > +			printk(" discovery_status(0x%08x)",
> I don't see any significant reason for changing print. It not adding any benefit.

It would look a little nicer to have a space after the ) that is printed 
by the previous statement.

julia
