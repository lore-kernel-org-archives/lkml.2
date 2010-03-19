Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0CSVcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:32:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0CSVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:32:46 -0400
Date: Fri, 19 Mar 2010 14:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: "Othman, Ossama" <ossama.othman@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Intel Restricted Access Region Handler
Message-Id: <20100319143222.72aee474.akpm@linux-foundation.org>
In-Reply-To: <20100315234508.GB4008@suse.de>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
	<20100314181040.GB28359@suse.de>
	<A5FE05C4C76E4C4CAB15D9962B96FC950C9A6D184E@orsmsx510.amr.corp.intel.com>
	<20100315234508.GB4008@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 16:45:08 -0700
Greg KH <gregkh@suse.de> wrote:

> On Mon, Mar 15, 2010 at 04:16:02PM -0700, Othman, Ossama wrote:
> > Greg, Randy,
> > 
> > > Can you also send me a patch, that adds a TODO file to the directory of
> > > this driver, that explains what you think needs to be done in order to
> > > get this code merged into the main portion of the kernel tree, and
> > > include your email address in it so that people who wish to send
> > > patches, know who to copy on them?
> > > 
> > > See the other drivers/staging/*/TODO files for an example of what is
> > > expected here.
> > 
> > I just resubmitted a consolidated patch that includes the TODO file
> > you requested, as well as the kernel-doc related updates that Randy
> > requested.  Randy, I know that you were not in a rush to get them.  I
> > just wanted to get them out of the way.
> 
> Looks good, I'll queue it up in a few days.

Then what happens?  I guess I still don't understand the -staging process.

Does the code get re-posted for re-review?  If so, who does this?  How
do we ensure that suitably experienced/motivated reviewers and testers
take a look at this code?

Or does it just fester in -staging until we get bored of it then it
gets merged anyway?

Regarding the code itself: it appears to implement a userspace
interface via some /dev node.  But there is no description of this
interface at all in the changelog and there is no documentation
provided.  But the userspace-facing interface is the most important
part of the entire feature, because it is something we cannot ever
change.  It should be exhaustively described right up-front in the
changelog so that reviewers can easily and fully understand the
proposed API.

