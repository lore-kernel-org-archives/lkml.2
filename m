Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1JXO2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:28:23 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44329 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390Ab1JXO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:28:22 -0400
X-Sasl-enc: ZKrfk8xJ0BkI6EiBLmx7UK2oQ0WbDrt6HUA2ExBHFZPB 1319466501
Date: Mon, 24 Oct 2011 16:22:05 +0200
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
Message-ID: <20111024142205.GA2687@kroah.com>
References: <20111023062833.GA8126@kroah.com>
 <20111023062540.684446582@pistachio.kroah.org>
 <CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
 <20111023083636.GA14048@suse.de>
 <87pqhnifew.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqhnifew.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 11:09:11PM +0200, Miklos Szeredi wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Sun, Oct 23, 2011 at 10:35:14AM +0300, Linus Torvalds wrote:
> >> This one is debatable.
> >> 
> >> I think it also wants
> >> 
> >>  - commit 0ec26fd0698285b31248e34bf1abb022c00f23d6 (with
> >> LOOKUP_PARENT->LOOKUP_CONTINUE too)
> >
> > Really?  I thought I dropped this one from the last stable release due
> > to problems with it, or does this patch here, and the one you mention
> > below, resolve those issues?
> >
> >>  - commit d94c177beeb4469cd4f6e83354ab0223353e98ed (to get the few
> >> other cases right too)
> >> 
> >> anything else I missed?
> >
> > Ok, that makes a bit more sense, I'll add these if David and Miklos
> > agree that they are ok to add here.  David and Miklos?
> 
> IMO they are OK to add as long as they are both added.
> 
> Last time the first one had to be backed out because Linus wasn't
> totally comfortable with the other one going into -stable until it got
> some testing in 3.1.  Or at least that's how I understood (or
> misunderstood).

Ok, I tried applying these patches, but they didn't apply.  I tried
digging the patches out of the suse kernel tree, but they didn't seem to
include all of the needed ones here.

So, I'm going to drop this patch from the 3.0.8 release, can someone
please send me the needed patches, backported to 3.0, so that I know
they are working properly?

thanks,

greg k-h
