Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1HZTHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:07:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab1HZTHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:07:10 -0400
Date: Fri, 26 Aug 2011 12:04:17 -0700
From: Greg KH <gregkh@suse.de>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>, joe@perches.com, jim.cromie@gmail.com,
        bvanassche@acm.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dynamic debug: cleanups + compile fix
Message-ID: <20110826190417.GA30356@suse.de>
References: <cover.1314291909.git.jbaron@redhat.com>
 <20110826182900.GA30226@kroah.com>
 <20110826184742.GA2469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826184742.GA2469@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 02:47:42PM -0400, Jason Baron wrote:
> On Fri, Aug 26, 2011 at 11:29:00AM -0700, Greg KH wrote:
> > On Thu, Aug 25, 2011 at 01:34:06PM -0400, Jason Baron wrote:
> > > Hi,
> > > 
> > > This is a re-post of the last 3 patches, as requested by Greg:
> > > https://lkml.org/lkml/2011/8/11/378
> > > 
> > > I've also added a compile fix that Randy Dunlap found in the -next tree.
> > 
> > Care to redo this based on the comments received so far?
> > 
> 
> Hi,
> 
> I re-posted 3/4 based on the comments already. The comment on patch #1
> regarding adding macro parenthesis, I don't believe makes any functional
> change...do you still need a re-post the series?

Yes, please fix patch #1 adding the needed parenthesis and resend the
whole series.

thanks,

greg k-h
