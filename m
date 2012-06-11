Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2FKI3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:29:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33313 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2FKI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:29:35 -0400
Date: Mon, 11 Jun 2012 11:29:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ipack: remove pr_fmt definition.
Message-ID: <20120611082902.GU4400@mwanda>
References: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
 <20120611072500.GT4400@mwanda>
 <20120611072736.GI13539@mwanda>
 <1339400404.3963.7.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339400404.3963.7.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 09:40:04AM +0200, Samuel Iglesias Gonsálvez wrote:
> On Mon, 2012-06-11 at 10:27 +0300, Dan Carpenter wrote:
> > On Mon, Jun 11, 2012 at 10:25:00AM +0300, Dan Carpenter wrote:
> > > On Mon, Jun 11, 2012 at 08:56:36AM +0200, Samuel Iglesias Gonsalvez wrote:
> > > > As there is no pr_* function used here, pr_fmt is not needed.
> > > > 
> > > 
> > > Nah.  What about if we decide to add some?  Also there are actually
> > > a couple pr_err() calls in there already.
> > 
> > Oops.  Sorry my tree is old.  We removed the two calls to pr_err().
> 
> Same mistake here. In greg's staging-next the pr_err calls are not
> present so the patch is totally valid but in linus branch they are there
> (this is the reason of my error).
> 
> So, this patch is valid, unless we want the pr_fmt definition for the
> future. However, I prefer to delete it.
> 

Sure.  I guess everything in staging/ipack/ uses dev_err() type
print statements and that includes more information than the the
pr_fmt() macro already.

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

