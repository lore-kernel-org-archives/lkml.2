Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab1JQRQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:16:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1JQRQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:16:12 -0400
Date: Mon, 17 Oct 2011 10:16:09 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Richard Weinberger <richard@nod.at>
Cc: Kyle Moffett <kyle@moffetthome.net>, Valdis.Kletnieks@vt.edu,
        jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        license-violation@gpl-violations.org
Subject: Re: OCFS2 1.6.0 for mainline?
Message-ID: <20111017171609.GD23779@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu> <4E99C7B7.5060405@nod.at> <33629.1318706796@turing-police.cc.vt.edu> <CAGZ=bqJb5FGJe264TOtfuzm8dyvWO883NFBnzkyA4M6Fe7Nq_g@mail.gmail.com> <4E99F74C.80900@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99F74C.80900@nod.at>
Organization: SUSE Labs
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 11:12:44PM +0200, Richard Weinberger wrote:
> >> Well, you have to admit it *is* an interesting business model - giving release
> >> N to your customers and N-1 to the world.  I just got totally mislead by the
> >> quote from the Oracle site that said the development happens in mainline. ;)
> > 
> > If someone who has a copy of Oracle's "Unbreakable Linux" can get
> > ahold of the sources, please put them in GIT somewhere for the rest of
> > us to access; it *is* GPLed software after all.  Otherwise, please
> > distribute the binaries to the rest of us and we will obtain the
> > sources on our own.  I can't find any published information on their
> > website about how to obtain the sources, so someone will have to
> > contact them directly.
> 
> I found this src.rpm:
> http://public-yum.oracle.com/repo/OracleLinux/OL6/1/base/x86_64/kernel-uek-2.6.32-100.34.1.el6uek.src.rpm
> 
> linux-2.6.32/fs/ocfs2 contains OCFS2 1.6.3.
> 
> Mark, Joel, can you please port this "release" to mainline?
> 
> Thanks,
> //richard

There's no point, everything in mainline is in that release (1.6.3). If
there's anything not in mainline that's there it should only be because of
the following reasons:

	- It is not suitable for mainline (the datavolume hack is one example)
	- It just hasn't been pushed yet but is in Joel's tree or is on the
          list waiting review.

If you see otherwise of course, please let us all know - including the
Oracle folks they really are keeping this upstream.

I think you all are being confused by two things:

 - meaningless version numbers - we don't care too much about version
   numbers in the upstream code since we can go about that by looking at
   kernel version. Oracle (and SUSE) on the other hand like to increase
   numbers for obvious customer reasons. Hence the upstream version just
   looks 'old'.

 - The confusing way in which Ocfs2 is presented on the oss.oracle.com site.
   There can be improvements in how things are worded and presented but that's
   really out of my control.

Again, let us know if you find anything that contradicts what I just wrote.
	--Mark

--
Mark Fasheh
