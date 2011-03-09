Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1CIRYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:24:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab1CIRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:24:34 -0500
Date: Wed, 9 Mar 2011 09:22:03 -0800
From: Greg KH <gregkh@suse.de>
To: andersen@codepoet.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32.33
Message-ID: <20110309172203.GA25943@suse.de>
References: <20110307232404.GA24927@kroah.com>
 <20110307232416.GB24927@kroah.com>
 <20110309171632.GA18029@mail.codepoet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309171632.GA18029@mail.codepoet.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:16:32AM -0700, Erik Andersen wrote:
> On Mon Mar 07, 2011 at 03:24:16PM -0800, Greg KH wrote:
> > diff --git a/Makefile b/Makefile
> > index e734450..c3f6287 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,7 +1,7 @@
> >  VERSION = 2
> >  PATCHLEVEL = 6
> >  SUBLEVEL = 32
> > -EXTRAVERSION = .31
> > +EXTRAVERSION = .32
> 
> In the email subject, you meant to say "Linux 2.6.32.32"...

So I did, sorry.

greg k-h
