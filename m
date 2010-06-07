Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0FGTYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:24:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44284 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0FGTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MYQ1ojYdxaNMwAOQ2LKzXR4flozjuJmz8EEPRjSPYm+iCNLUKj8B0TKCB96noGv/uv
         zWlTP/7+TV2w/nJ3zEDLE4hNT6KzXeQOxqUeoZusF7ZYvJO6SrXgPDOs0Kl8UeXpwEFH
         dIARFm5JAL7knhMyUHgA3MILwcI6ifavOuC+c=
Date: Mon, 7 Jun 2010 12:21:59 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/17] MAINTAINERS: Add STAGING - INDUSTRIAL IO
Message-ID: <20100607192158.GA10882@fujitsu>
References: <cover.1275935090.git.joe@perches.com>
 <81391f52a009e825f5a3bfd73a71ba24190d6f3b.1275935091.git.joe@perches.com>
 <4C0D3FFB.7040704@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C0D3FFB.7040704@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 07:52:43PM +0100, Jonathan Cameron wrote:
> On 06/07/10 19:49, Joe Perches wrote:
> 
> Good idea.  Could we have the mailing list as well.
> L: linux-iio@vger.kernel.org

Maybe the mailing list could be added to the TODO file too, it only
mentions the LKML.

> I can do it as an incremental patch if you would prefer.
> Either way,
> 
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  MAINTAINERS |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 71e6fe3..680d602 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5497,6 +5497,11 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
> >  S:	Odd Fixes
> >  F:	drivers/staging/hv/
> >  
> > +STAGING - INDUSTRIAL IO
> > +M:	Jonathan Cameron <jic23@cam.ac.uk>
> > +S:	Odd Fixes
> > +F:	drivers/staging/iio/
> > +
> >  STARFIRE/DURALAN NETWORK DRIVER
> >  M:	Ion Badulescu <ionut@badula.org>
> >  S:	Odd Fixes
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

-- 
Charles Clément

