Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965810Ab2DLTQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:16:14 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:64089 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2DLTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:16:13 -0400
Date: Thu, 12 Apr 2012 21:16:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120412191611.GB30472@merkur.ravnborg.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org> <1334162178-17152-6-git-send-email-bp@amd64.org> <20120411180434.GH16257@infradead.org> <20120411180837.GJ16257@infradead.org> <20120412152256.GH24549@aftab> <20120412155734.GA30170@merkur.ravnborg.org> <20120412183351.GQ16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412183351.GQ16257@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 03:33:51PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Apr 12, 2012 at 05:57:34PM +0200, Sam Ravnborg escreveu:
> > > diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> > > index 87b55a729a5f..297b51d8e4be 100644
> > > --- a/tools/scripts/Makefile.include
> > > +++ b/tools/scripts/Makefile.include
> > > @@ -38,11 +38,18 @@ else
> > >  NO_SUBDIR = :
> > >  endif
> > >  
> > > -QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
> > > -QUIET_SUBDIR1  =
> > 
> > Who-ever came up with the names "QUIET_SUBDIR" must have had a bad day...
> 
> Came from the git sources, where it still lives on:
> 
> [acme@sandy git]$ git show b7774343
> commit b777434383bd2f365be6896d8c89be6c1b62a135
> Author: Alex Riesen <raa.lkml@gmail.com>
> Date:   Wed Mar 7 00:44:49 2007 +0100
> 
>     Support of "make -s": do not output anything of the build itself
>     
>     Signed-off-by: Junio C Hamano <junkio@cox.net>

Part of the git build infrastructure has not impressed me - others parts are good.
But then it is more than a year since I actually looked at it.

And no - I have no time left to actually do anything about it.

	Sam
