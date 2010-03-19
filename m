Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0CSVmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:42:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0CSVmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:42:10 -0400
Date: Fri, 19 Mar 2010 14:40:31 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Othman, Ossama" <ossama.othman@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Intel Restricted Access Region Handler
Message-ID: <20100319214031.GA12391@suse.de>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
 <20100314181040.GB28359@suse.de>
 <A5FE05C4C76E4C4CAB15D9962B96FC950C9A6D184E@orsmsx510.amr.corp.intel.com>
 <20100315234508.GB4008@suse.de>
 <20100319143222.72aee474.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319143222.72aee474.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 02:32:22PM -0700, Andrew Morton wrote:
> On Mon, 15 Mar 2010 16:45:08 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, Mar 15, 2010 at 04:16:02PM -0700, Othman, Ossama wrote:
> > > Greg, Randy,
> > > 
> > > > Can you also send me a patch, that adds a TODO file to the directory of
> > > > this driver, that explains what you think needs to be done in order to
> > > > get this code merged into the main portion of the kernel tree, and
> > > > include your email address in it so that people who wish to send
> > > > patches, know who to copy on them?
> > > > 
> > > > See the other drivers/staging/*/TODO files for an example of what is
> > > > expected here.
> > > 
> > > I just resubmitted a consolidated patch that includes the TODO file
> > > you requested, as well as the kernel-doc related updates that Randy
> > > requested.  Randy, I know that you were not in a rush to get them.  I
> > > just wanted to get them out of the way.
> > 
> > Looks good, I'll queue it up in a few days.
> 
> Then what happens?  I guess I still don't understand the -staging process.
> 
> Does the code get re-posted for re-review?  If so, who does this?  How
> do we ensure that suitably experienced/motivated reviewers and testers
> take a look at this code?

The code lives in the drivers/staging tree for a while, constantly being
cleaned up and the issues in the original TODO file addressed.  When
those are finished, and me and the original authors feel the driver is
ready to move into the main portion of the kernel tree, the code is then
posted for review for the subsystem that the driver lives in.

After a few rounds of fixing stuff up there, then the code moves into
that subsystem and everyone lives happily ever after.

> Or does it just fester in -staging until we get bored of it then it
> gets merged anyway?

No, if it festers and no one pays attention to it, I delete it from the
drivers/staging tree.  Lots of code has been recently removed this way.

> Regarding the code itself: it appears to implement a userspace
> interface via some /dev node.  But there is no description of this
> interface at all in the changelog and there is no documentation
> provided.  But the userspace-facing interface is the most important
> part of the entire feature, because it is something we cannot ever
> change.  It should be exhaustively described right up-front in the
> changelog so that reviewers can easily and fully understand the
> proposed API.

I agree, that is one thing that always needs to be closely reviewed.

thanks,

greg k-h
