Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2GQVXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:23:11 -0400
Received: from vostochny.stro.at ([78.47.22.85]:53063 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab2GQVXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:23:06 -0400
Date: Tue, 17 Jul 2012 21:23:05 +0000
From: maximilian attems <max@stro.at>
To: =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] scripts/package/builddeb: upgrade to current practices
Message-ID: <20120717212305.GV28778@vostochny.stro.at>
References: <1342547874.5129.2.camel@henna.lan>
 <20120717193951.GA15208@burratino>
 <CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:46:23PM +0300, Martin-Éric Racine wrote:
> 2012/7/17 Jonathan Nieder <jrnieder@gmail.com>:
> >>
> >>  Package: $fwpackagename
> >>  Architecture: all
> >> +Conflicts: firmware-linux-free, firmware-linux-nonfree
> >> +Provides: firmware-linux-free, firmware-linux-nonfree
> >> +Replaces: firmware-linux-free, firmware-linux-nonfree
> >
> > I assume you mean Breaks+Replaces.  Do the files actually overlap,
> > or is this change being overly cautious?  I would expect the files
> > not to overlap because the package build with deb-pkg puts firmware
> > in a versioned subdirectory "/lib/firmware/<version>".
> 
> AFAIK they would overlap, hence the Conflicts.

This is wrong and properly fixed in -next.

-- 
maks
