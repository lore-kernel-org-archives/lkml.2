Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0FBUR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:17:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:49428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab0FBUR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:17:57 -0400
Date: Wed, 2 Jun 2010 13:17:17 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: Add staging/b.a.t.m.a.n
Message-ID: <20100602201717.GA8803@suse.de>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
 <20100602185323.GA6600@suse.de>
 <1275509319.23599.40.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275509319.23599.40.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:08:39PM -0700, Joe Perches wrote:
> On Wed, 2010-06-02 at 11:53 -0700, Greg KH wrote:
> > The TODO file in this directory clearly states who to copy on patches to
> > these files.
> 
> Does anyone look at those? ;)

Yes, they should.

Heck, get_maintainer.pl would have given you the correct people to cc:
as well, why not use that?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2652ebc..e25e15a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5436,6 +5436,14 @@ L:	devel@driverdev.osuosl.org
>  S:	Maintained
>  F:	drivers/staging/
>  
> +STAGING B.A.T.M.A.N.
> +M:	Marek Lindner <lindner_marek@yahoo.de>
> +M:	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> +M:	Andrew Lunn <andrew@lunn.ch>
> +L:	b.a.t.m.a.n@lists.open-mesh.net
> +S:	Maintained (one day soon)
> +F:	drivers/staging/batman-adv/

Care to at least cc: the people who you are adding to the file?

To not do so is a bit rude, don't you think so?

I'm not going to take this, sorry.

greg k-h
