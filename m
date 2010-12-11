Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab0LKHTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 02:19:30 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:58453 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0LKHT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 02:19:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ijqxwEU13a4I+hducCzpWlt/Rg3Fgx5ApPbPOadxTUtOQzeFFf6sT8tvnLSXakSR+9
         jSr8/+vJWtPXF1z8BRhBVV8fXhJgBzxZwkeoqcsOoqjfhDN+QoINfli/53OpMF47vfM0
         nJVcHhPdYSdcl8dAAgr04OmUsmvncbxxBzwcY=
Date: Sat, 11 Dec 2010 15:18:46 +0800
From: HarryWei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CodingStyle
Message-ID: <20101211071838.GA10959@gmail.com>
References: <90e6ba4fc2a4f7dd3c04971cb0fa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90e6ba4fc2a4f7dd3c04971cb0fa@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/12/11 Robert P. J. Day <rpjday@crashcourse.ca>
> 
> > On Sat, 11 Dec 2010, HarryWei wrote:
> >
> > > Hi all,
> > >       I just read the CodingSyle at Documentation directory in
> > linux-2.6.23 kernel source code.
> > >       But a problem happened to me like following.
> > >       Functions in linux-2.6.23/fs/fs-writeback.c are "static int" and
> > function name are in different lines.(function name in following line)
> > >       I can't find the rule in CodingStyle. That We often program
> > functions are "static int" and function name are in the same line.
> > >       When do we do the first or second way? What is different between
> > them?
> > >
> > >   Any answer is okay.
> > >   Best regards.
> >
> >   the advantage to the form
> >
> > static int
> > function-name
> >
> > is that, if you're looking for the actual function *definition* in the
> > file, having the function name at the start of a new line means you
> > can search for it with the pattern "^function-name" so that you don't
> > have to wade through all of the invocations of that function.
> >
> >  i like that style; others claim that with proper cross-referencers
> > like cscope, doing that is redundant.  as far as i know, the kernel
> > coding style doesn't take a position on that, but i'm willing to be
> > corrected.
Thanks, i see :)
> >
> > rday
> >
> > --
> >
> > ========================================================================
> > Robert P. J. Day                               Waterloo, Ontario, CANADA
> >                        http://crashcourse.ca
> >
> > Twitter:                                       http://twitter.com/rpjday
> > LinkedIn:                               http://ca.linkedin.com/in/rpjday
> > ========================================================================
> >
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!
