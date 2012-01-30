Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2A3VTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:19:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab2A3VTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:19:42 -0500
Date: Mon, 30 Jan 2012 13:15:50 -0800
From: Greg KH <gregkh@suse.de>
To: Junio C Hamano <junio@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 3.3-rc1
Message-ID: <20120130211550.GB13580@suse.de>
References: <20120127230946.GA23528@kroah.com>
 <7v7h0cxm1j.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7v7h0cxm1j.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 12:34:48AM -0800, Junio C Hamano wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > I tried to create a signed tag for this pull request.  It's call
> > "driver-core-3.3-rc1-bugfixes" in the repo below, but when I did:
> >     git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-3.3-rc1-bugfixes > msg.txt
> >
> > I got the text below, no signed tag with the wording that I added to it
> > that I could see.  Now I am still using git 1.7.8.3, is that why?
> 
> Ehh, the older versions never expected people to ask a tag to be pulled in
> the first place, so there is no way they would have known to unwrap the
> tag and pasted its tag message in the output ;-).

Heh, fair enough :)

> The request-pull script in 1.7.9 has finally received some belated
> love. Since mid 2009, it didn't get much updates that improve the user
> visible experience.

As most of us used our own scripts for this, that makes sense, nice to
see it cleaned up a lot, I'll use it for my requests after I get 1.7.9
installed on my systems...

greg k-h
