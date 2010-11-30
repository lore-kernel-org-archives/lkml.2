Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0K3TVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:21:04 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51438 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752580Ab0K3TVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:21:02 -0500
Date: Tue, 30 Nov 2010 20:20:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org
Cc: ecc@cmu.edu
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101130192053.GB5295@ucw.cz>
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
 <20101117195843.GA31357@elf.ucw.cz>
 <20101117200614.GK15096@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117200614.GK15096@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please preserve cc lists.

> > I was hoping you'd comment on the ABI itself, too. It uses 
> > 
> > echo "foo bar baz" > file
> > 
> > to enable/disable specific events to be "displayed". More traditional
> > interface would be 
> > 
> > echo disable > file_foo
> 
> The main arguments for using the single "mode" file are:
> 1. that's how it was implemented for OpenWrt, and there's a fair
>    amount of userland (web admin tools, etc.) that groks it

That's not good reason...

> 2. it's only specifying a set of three possible values -- separate
>    files seem like overkill

Does it? AFAICT it allowed any combination of 3 -- IOW 2^3 values.

Please be consistent with rest of kernel...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
