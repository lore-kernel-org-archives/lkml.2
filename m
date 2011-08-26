Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1HZWS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1HZWS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:18:56 -0400
Date: Fri, 26 Aug 2011 15:18:45 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, Greg KH <greg@kroah.com>,
        jim.cromie@gmail.com, bvanassche@acm.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dynamic debug: cleanups + compile fix
Message-ID: <20110826221845.GA18858@suse.de>
References: <cover.1314291909.git.jbaron@redhat.com>
 <20110826182900.GA30226@kroah.com>
 <20110826184742.GA2469@redhat.com>
 <20110826190417.GA30356@suse.de>
 <1314396881.9624.8.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314396881.9624.8.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 03:14:41PM -0700, Joe Perches wrote:
> On Fri, 2011-08-26 at 12:04 -0700, Greg KH wrote:
> > On Fri, Aug 26, 2011 at 02:47:42PM -0400, Jason Baron wrote:
> > > On Fri, Aug 26, 2011 at 11:29:00AM -0700, Greg KH wrote:
> > > > On Thu, Aug 25, 2011 at 01:34:06PM -0400, Jason Baron wrote:
> > > > > Hi,
> > > > > 
> > > > > This is a re-post of the last 3 patches, as requested by Greg:
> > > > > https://lkml.org/lkml/2011/8/11/378
> > > > > 
> > > > > I've also added a compile fix that Randy Dunlap found in the -next tree.
> > > > 
> > > > Care to redo this based on the comments received so far?
> > > > 
> > > 
> > > Hi,
> > > 
> > > I re-posted 3/4 based on the comments already. The comment on patch #1
> > > regarding adding macro parenthesis, I don't believe makes any functional
> > > change...do you still need a re-post the series?
> > 
> > Yes, please fix patch #1 adding the needed parenthesis and resend the
> > whole series.
> 
> The parentheses aren't need.
> 
> A macro like
> #define foo(a, b) a = b
> 
> that only uses each argument once without doing arithmetic
> gains nothing from parentheses.
> 
> Just like
> #define true 1
> gains nothing from parenthesis either.

I don't think that is the case here, right?

greg k-h
