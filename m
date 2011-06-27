Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab1F0K1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab1F0K0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:26:44 -0400
Date: Mon, 27 Jun 2011 12:26:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: =?ISO-8859-15?Q?Torbj=F6rn_Svensson?= 
	<azoff@svenskalinuxforeningen.se>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Corrected a small typo in help text for
 CONFIG_CLEANCACHE
In-Reply-To: <alpine.LNX.2.00.1106260043570.23991@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106271226260.11049@pobox.suse.cz>
References: <4E06633F.9010307@svenskalinuxforeningen.se> <alpine.LNX.2.00.1106260043570.23991@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011, Jesper Juhl wrote:

> > Signed-of-by: Torbjörn Svensson <azoff@svenskalinuxforeningen.se>
> > ---
> >  mm/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 8ca47a5..f2f1ca1 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -356,7 +356,7 @@ config CLEANCACHE
> >  	  for clean pages that the kernel's pageframe replacement algorithm
> >  	  (PFRA) would like to keep around, but can't since there isn't enough
> >  	  memory.  So when the PFRA "evicts" a page, it first attempts to use
> > -	  cleancacne code to put the data contained in that page into
> > +	  cleancache code to put the data contained in that page into
> >  	  "transcendent memory", memory that is not directly accessible or
> >  	  addressable by the kernel and is of unknown and possibly
> >  	  time-varying size.  And when a cleancache-enabled
> > 
> For what it's worth;
> 
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>

Already fixed in my tree by 140a1ef2f.

-- 
Jiri Kosina
SUSE Labs
