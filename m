Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0H1TV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:21:58 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42199 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0H1TV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:21:57 -0400
Date: Sat, 28 Aug 2010 21:21:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Comments to apparmor Makefile (and security/Makefile)
Message-ID: <20100828192155.GA9287@merkur.ravnborg.org>
References: <20100828070305.GA8842@merkur.ravnborg.org> <4C795F6F.40202@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C795F6F.40202@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > 8) From security/Makefile:
> > 
> >     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/built-in.o
> > This is _not_ how we do it.
> > 
> > We say just:
> > 
> >     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/
> > 
> > [security/Makefile has this issue in several places]
> > 
> okay, I set it up this way to conform to other entries in the file
> If we are going to fix apparmor's entry we should fix them all

Agreed - its better to fix them all in one go.
I assume you do this in a follow-up patch - it is straightforward.

> 
> > There was a few tings that made me unsafe just providing a patch,
> > so for now you got a list of comments.
> > 
> > 	Sam
> 
> np, thanks for the comments, patch attached
Looks much better - and thanks for the quick response!

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
