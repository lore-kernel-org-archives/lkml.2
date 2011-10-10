Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1JJRlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:41:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1JJRlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:41:01 -0400
Date: Mon, 10 Oct 2011 19:40:58 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 4/6] udf: Convert printks to pr_<level>
Message-ID: <20111010174058.GJ3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
 <cover.1318233879.git.joe@perches.com>
 <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
 <20111010145953.GC3944@quack.suse.cz>
 <1318260214.25811.14.camel@Joe-Laptop>
 <20111010164157.GH3944@quack.suse.cz>
 <1318267510.27825.20.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318267510.27825.20.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-10-11 10:25:10, Joe Perches wrote:
> On Mon, 2011-10-10 at 18:41 +0200, Jan Kara wrote:
> > On Mon 10-10-11 08:23:34, Joe Perches wrote:
> > > I forgot to mention that udf_err emits at KERN_CRIT.
> > > I think that's not good.
> > I've changed udf_err() to call pr_err() because
> > KERN_CRIT is really too much.
> 
> If this means you applied it or applied it with
> modifications, I think it'd be good to either
> reply to the 0/n message with something like
> "applied to my tree", or reply to each message
> as appropriate.
  Sure, that's what I wanted to do but I first wanted to test what I have,
stumbled across an issue with patch 1 which delayed me a bit...

> That reply lets other people like NamJae proceed
> appropriately.  Otherwise, it's left to some
> pull request or patch series posted by you
> potentially months later to figure out what's
> current.
> 
> Is there a udf git tree?
  On kernel.org which is down... I didn't bother to setup some other place
yet.

> The stuff on sourceforge is not current
> and the MAINTAINERS W: entry doesn't work.
  Actually, the link is ancient and I don't use SF for UDF development so
I've added a patch to my tree which removes the link.
  
> 
> Maybe:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 644894a..58eb5f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6624,7 +6624,7 @@ F:	drivers/net/ethernet/8390/ne-h8300.c
>  
>  UDF FILESYSTEM
>  M:	Jan Kara <jack@suse.cz>
> -W:	http://linux-udf.sourceforge.net
> +W:	http://sourceforge.net/projects/linux-udf/develop
>  S:	Maintained
>  F:	Documentation/filesystems/udf.txt
>  F:	fs/udf/
> 
> cheers, Joe
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
