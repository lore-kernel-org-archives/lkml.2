Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2A3VTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:19:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2A3VTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:19:38 -0500
Date: Mon, 30 Jan 2012 13:14:56 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [GIT PATCH] driver core patches for 3.3-rc1
Message-ID: <20120130211456.GA13580@suse.de>
References: <20120127230946.GA23528@kroah.com>
 <CA+55aFxeFWnuywj2x5xzQhXg6NWQENpK=n=V1xHvMJZncFhYMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxeFWnuywj2x5xzQhXg6NWQENpK=n=V1xHvMJZncFhYMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 06:22:41PM -0800, Linus Torvalds wrote:
> On Fri, Jan 27, 2012 at 3:09 PM, Greg KH <gregkh@suse.de> wrote:
> > I tried to create a signed tag for this pull request.  It's call
> > "driver-core-3.3-rc1-bugfixes" in the repo below, but when I did:
> >    git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-3.3-rc1-bugfixes > msg.txt
> >
> > I got the text below, no signed tag with the wording that I added to it
> > that I could see.  Now I am still using git 1.7.8.3, is that why?  If
> > so, I'll go build 1.7.9 as I see that is now out today.
> >
> > Did I mess something up?  I created the tag with:
> >    git tag -u kroah.com -s driver-core-3.3-rc1-bugfixes driver-core-linus
> 
> No, everything looks fine, and I just pulled it.
> 
> But your old version of git won't be able to do that pull (or
> request-pull) since it doesn't have support for the signed tag
> feature. So the signed tag itself works fine, and I can pull from you,
> but yes, you need to have a newer version yourself to see how that
> works.

Ok, thanks for verifying that I didn't mess anything up on my side.

greg k-h
