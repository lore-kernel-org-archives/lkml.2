Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0H3SjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab0H3SjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:39:06 -0400
Date: Mon, 30 Aug 2010 14:38:43 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100830183843.GB2444@shell>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827213502.31af4a4c@notabene>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:35:02PM +1000, Neil Brown wrote:
> On Fri, 27 Aug 2010 10:47:39 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > Changes to underlying filesystems
> > > ---------------------------------
> > > 
> > 
> > For now I refuse to even think about what happens in this case.
> > 
> > The easiest way out of this mess might simply be to enforce exclusive
> > modification to the underlying filesystems on a local level, same as
> > the union mount strategy.  For NFS and other remote filesystems we
> > either
> > 
> >  a) add some way to enforce it,
> >  b) live with the consequences if not enforced on the system level, or
> >  c) disallow them to be part of the union.
> > 
> 
> I actually think that your approach can work quite will with either the
> upper or lower changing independently.  Certainly it can produce some odd
> situations, but even NFS can do that (though maybe not quite so odd).

I'm very curious about your thoughts on how to handle the lower layer
changing.  Al Viro's comments:

http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html

Do you see something we're missing?

-VAL
