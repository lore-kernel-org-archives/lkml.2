Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1JWIgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:36:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab1JWIgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:36:43 -0400
Date: Sun, 23 Oct 2011 10:36:36 +0200
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Chuck Ebbert <cebbert@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [22/27] VFS: Fix automount for negative autofs dentries
Message-ID: <20111023083636.GA14048@suse.de>
References: <20111023062833.GA8126@kroah.com>
 <20111023062540.684446582@pistachio.kroah.org>
 <CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxkHr75LZU0udv=A+Bg52fMMOEfp47TTxHGbgf51UouRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 10:35:14AM +0300, Linus Torvalds wrote:
> This one is debatable.
> 
> I think it also wants
> 
>  - commit 0ec26fd0698285b31248e34bf1abb022c00f23d6 (with
> LOOKUP_PARENT->LOOKUP_CONTINUE too)

Really?  I thought I dropped this one from the last stable release due
to problems with it, or does this patch here, and the one you mention
below, resolve those issues?

>  - commit d94c177beeb4469cd4f6e83354ab0223353e98ed (to get the few
> other cases right too)
> 
> anything else I missed?

Ok, that makes a bit more sense, I'll add these if David and Miklos
agree that they are ok to add here.  David and Miklos?

greg k-h
