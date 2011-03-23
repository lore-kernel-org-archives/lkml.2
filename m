Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1CWHAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:00:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36874 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1CWHAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=JdvSraMFsC+UCUe9C6UyrWDFO0pxJnDf0oJJv7JQ170gK1PbYpOQ+sl2Qh41jJHWku
         oRhBSSc8TGeLRCRUD8h0oj1iRUmiP5FCY6ll00tXewOJA0yLq7p/iKfyG45YpnUJSsvo
         Ptlwjm1LZoIMlk2LAHUvoABiIQgE9rHIbhp3E=
Date: Wed, 23 Mar 2011 15:00:20 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH]Clean up CodingStyle for scripts/kconfig/gconf.c
Message-ID: <20110323070017.GA3731@gmail.com>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org
References: <20110322143839.GA10291@gmail.com>
 <4D894CD0.9030509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D894CD0.9030509@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:28:48AM +0800, Li Zefan wrote:
> Harry Wei wrote:
> > Hi us,
> >    	Clean up CodingStyle for scripts/kconfig/gconf.c.
> > 
> 
> What makes you think this is a bad style? Does Documentation/CodingStyle say
> so? Does checkpatch.pl make a complain? Do you really think this improves
> readability? I don't think so, and actually it makes the code worse.
But we all write '#include <***>'. I have never seen '#  include <***>'.
> 
> Run checkpatch.pl on this file, and you'll see lots of errors and warnings,
> but pure codingstyle cleanup is rarely worth anything, so better don't do
> that.
I am sorry, I have not got your meaning clearly.
> 
> > Thanks.
> > Best Regards.
> > Harry Wei.
> > 
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > ---
> >  scripts/kconfig/gconf.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> > index 4558961..56da945 100644
> > --- a/scripts/kconfig/gconf.c
> > +++ b/scripts/kconfig/gconf.c
> > @@ -7,7 +7,7 @@
> >   */
> >  
> >  #ifdef HAVE_CONFIG_H
> > -#  include <config.h>
> > +#include <config.h>
> >  #endif
> >  
> >  #include "lkc.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
