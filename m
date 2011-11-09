Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1KIMS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:18:27 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:44486 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1KIMS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:18:26 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8838359"
Subject: Re: [Xen-devel] RE: [PATCH 3/3] code clean up
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 9 Nov 2011 12:18:23 +0000
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B4543AB1BE@LONPMAILBOX01.citrite.net>
References: <4EBA35D3.3020506@oracle.com>
	 <1320826574-29427-1-git-send-email-annie.li@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B4543AB1BE@LONPMAILBOX01.citrite.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1320841103.955.120.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 11:15 +0000, Paul Durrant wrote:
> Annie,
> 
>   Why was this split out as a separate patch? Can it not be folded into patch 2 since the line it re-formats was introduced there?

It is not generally necessary to split string constants in order to meet
the 80 column (soft) limit in Linux code. Some people frown on it
because it breaks grep'ability.

Ian.

> 
>   Paul
> 
> > -----Original Message-----
> > From: annie.li@oracle.com [mailto:annie.li@oracle.com]
> > Sent: 09 November 2011 08:16
> > To: xen-devel@lists.xensource.com; linux-kernel@vger.kernel.org;
> > konrad.wilk@oracle.com; jeremy@goop.org
> > Cc: kurt.hackel@oracle.com; Paul Durrant; annie.li@oracle.com
> > Subject: [PATCH 3/3] code clean up
> > 
> > From: Annie Li <annie.li@oracle.com>
> > 
> > Signed-off-by: Annie Li <annie.li@oracle.com>
> > ---
> >  drivers/xen/grant-table.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index a3294a26..458c00d 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -708,7 +708,8 @@ static void gnttab_request_version(void)  {
> >  	int rc;
> >  	struct gnttab_set_version gsv;
> > -	const char *str = "we need grant tables version 2, but only
> > version 1 is available\n";
> > +	const char *str = "we need grant tables version 2, "
> > +					"but only version 1 is
> > available\n";
> > 
> >  	gsv.version = 2;
> >  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv,
> > 1);
> > --
> > 1.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


