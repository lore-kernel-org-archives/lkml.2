Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0HRWun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:50:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab0HRWul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:50:41 -0400
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
From: James Bottomley <James.Bottomley@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
In-Reply-To: <4C6C5561.5040302@fusionio.com>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>
	 <20100817223145.GC4641@Krystal>  <4C6BC72E.6040607@gmail.com>
	 <1282141930.3035.9.camel@mulgrave.site>  <4C6BEFD1.8010200@gmail.com>
	 <1282142498.3035.17.camel@mulgrave.site>  <4C6C5561.5040302@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 17:50:33 -0500
Message-ID: <1282171834.13811.51.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 17:49 -0400, Jens Axboe wrote:
> On 08/18/2010 10:41 AM, James Bottomley wrote:
> > On Wed, 2010-08-18 at 16:36 +0200, Jiri Slaby wrote:
> >> On 08/18/2010 04:32 PM, James Bottomley wrote:
> >>>> James and Jens, could you take the two remaining (SCSI and BLOCK)?
> >>>
> >>> Sure ... could you identify the email by subject, please? lkml.org seems
> >>> to be down this morning.
> >>
> >> Sure:
> >> [PATCH v2] BLOCK: fix bio.bi_rw handling
> >> and
> >> [PATCH v2] SCSI: fix bio.bi_rw handling
> >>
> >> You should have received one copy to your suse.de inbox, if everything
> >> worked.
> > 
> > Got it.  One of life's little ironies is that I couldn't immediately
> > locate it in the SCSI list because it was already queued for inclusion.
> 
> Please add my acked-by to both of them.

OK.

>  I'm away on vacation, so if
> you James could queue them up, I would appreciate it. Thanks!

Certainly sir ... and would you like your patches served to your table
or by the pool?

James


