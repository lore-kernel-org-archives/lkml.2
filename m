Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2BBAJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:09:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36031 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab2BBAJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:09:46 -0500
X-Sasl-enc: +BdZOFhOZJsk/4Jm3SKTO/pn9pJHi30tYYrR2ULp4TGy 1328141385
Date: Wed, 1 Feb 2012 16:09:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [06/20] crypto: sha512 - reduce stack usage to safe number
Message-ID: <20120202000919.GA7870@kroah.com>
References: <20120201210055.GA25374@kroah.com>
 <20120201201531.599621544@clark.kroah.org>
 <20120201234208.GA28700@p183.telecom.by>
 <20120201235204.GA18950@kroah.com>
 <20120202000450.GA18441@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202000450.GA18441@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:04:51AM +1100, Herbert Xu wrote:
> On Wed, Feb 01, 2012 at 03:52:04PM -0800, Greg KH wrote:
> >
> > But this patch isn't in Linus's tree yet, right?
> > 
> > So, should I just drop this one for now (well both of them) or just wait
> > for the above referenced patch to hit Linus's tree and handle it then?
> 
> We're still working on the i386 issue.  However, I'd say that
> you should take these two patches now since the problem they
> fix is far worse than the potential stack issue on i386.

Ok, thanks for letting me know, I'll leave these patches in.

greg k-h
