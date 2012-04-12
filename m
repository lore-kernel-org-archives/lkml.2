Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab2DLTbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:31:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:34841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175Ab2DLTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:31:49 -0400
Date: Thu, 12 Apr 2012 16:31:50 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120412193150.GR16257@infradead.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org>
 <20120412152256.GH24549@aftab>
 <20120412155734.GA30170@merkur.ravnborg.org>
 <20120412183351.GQ16257@infradead.org>
 <20120412191611.GB30472@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412191611.GB30472@merkur.ravnborg.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 12, 2012 at 09:16:11PM +0200, Sam Ravnborg escreveu:
> On Thu, Apr 12, 2012 at 03:33:51PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Apr 12, 2012 at 05:57:34PM +0200, Sam Ravnborg escreveu:
> > > Who-ever came up with the names "QUIET_SUBDIR" must have had a bad day...

> > Came from the git sources, where it still lives on:

> > [acme@sandy git]$ git show b7774343
> > commit b777434383bd2f365be6896d8c89be6c1b62a135
> > Author: Alex Riesen <raa.lkml@gmail.com>
> > Date:   Wed Mar 7 00:44:49 2007 +0100
> >     Support of "make -s": do not output anything of the build itself
> >     Signed-off-by: Junio C Hamano <junkio@cox.net>

> Part of the git build infrastructure has not impressed me - others parts are good.
> But then it is more than a year since I actually looked at it.
> 
> And no - I have no time left to actually do anything about it.

Neither me, similar impressions, for the Makefiles, I really want us to
move to what is used by our landlord, the kernel :-)

I also can see doing a 'make tools/menuconfig' to select what we want to
build in a particular perf build, for instance, I received requests for
building just 'perf record' to use it in embedded systems, collect your
events, push it to another machine, where one would use a full featured
perf build.

Or one without perl, if one hates that thing :-)

- Arnaldo
