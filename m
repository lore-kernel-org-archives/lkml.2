Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab1ESUj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:39:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968Ab1ESUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:39:55 -0400
Date: Thu, 19 May 2011 13:39:16 -0700
From: Greg KH <gregkh@suse.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-media@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: Fw: [PATCH -next RESEND/still needed] staging: altera-jtag needs
 delay.h
Message-ID: <20110519203916.GA28736@suse.de>
References: <20110328082305.c6fa41d9.randy.dunlap@oracle.com>
 <4DD56DDE.6060003@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD56DDE.6060003@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:22:06PM -0300, Mauro Carvalho Chehab wrote:
> Em 28-03-2011 12:23, Randy Dunlap escreveu:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > altera-jtag.c needs to include <linux/delay.h> to fix a build error:
> > 
> > drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> > Cc: Igor M. Liplianin <liplianin@netup.ru>
> > ---
> >  drivers/staging/altera-stapl/altera-jtag.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Somehow I was supposed to know to send this to Mauro instead of to Greg,
> > but I don't see anything in drivers/staging/altera-stapl/ that says that.
> 
> Ah, yes, we need to add a readme file there stating about that.
> 
> Greg, you may add it on your tree, or if you prefer, I can just add here for
> my next upstream pull.

I see this in my tree already, git commit
92ce52695ccf2b6c4ef7eb02e1bee1bcbf5fde89, what happened to need this
again?

confused,

greg k-h
