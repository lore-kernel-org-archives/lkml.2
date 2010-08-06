Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab0HFVHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:07:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:40980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964819Ab0HFVHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:07:22 -0400
Date: Fri, 6 Aug 2010 14:06:19 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>, Jeff Layton <jlayton@redhat.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [26/34] CIFS: Fix compile error with __init in
 cifs_init_dns_resolver() definition
Message-ID: <20100806210619.GA5863@suse.de>
References: <20100806185836.185076461@clark.site>
 <1281127997.7543.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281127997.7543.0.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 09:53:17PM +0100, Ben Hutchings wrote:
> On Fri, 2010-08-06 at 11:57 -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> >  [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
> > 
> > From: Michael Neuling <mikey@neuling.org>
> > 
> > An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this error
> > 
> > fs/cifs/dns_resolve.h:27: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'cifs_init_dns_resolver'
> > 
> > This adds the correct header file to fix this.
> [...]
> 
> Why <linux/module.h> and not <linux/init.h>?

Heh, it works :)

Michael?

thanks,

greg k-h
