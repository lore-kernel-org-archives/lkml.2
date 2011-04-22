Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1DVXIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:08:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:29576 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1DVXIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="682738059"
Subject: Re: [PATCH] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110422230418.GA2793@suse.de>
References: <james_p_freyensee@linux.intel.com>
	 <1303511744-815-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110422224308.GA301@suse.de> <1303513182.13457.134.camel@localhost>
	 <20110422230418.GA2793@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 22 Apr 2011 16:08:16 -0700
Message-ID: <1303513696.13457.137.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 16:04 -0700, Greg KH wrote:
> On Fri, Apr 22, 2011 at 03:59:42PM -0700, J Freyensee wrote:
> > On Fri, 2011-04-22 at 15:43 -0700, Greg KH wrote:
> > > On Fri, Apr 22, 2011 at 03:35:44PM -0700, james_p_freyensee@linux.intel.com wrote:
> > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > 
> > > > This allows drivers who call this function to be compiled modularly.
> > > > Otherwise, a driver who is interested in this type of functionality
> > > > has to implement their own get_task_comm() call, causing code
> > > > duplication in the Linux source tree.
> > > > 
> > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > 
> > > I think the goal is for the cleanup to happen now, to justify the
> > > addition of the exported symbol.  Without that, there is no need to
> > > export the symbol now at all, as who knows when your driver will be
> > > accepted.
> > > 
> > > Or, just wait and make it part of your driver patch series, like you did
> > > before, no need to get it accepted now, right?
> > >
> > 
> > Well, at some point a few people like Alan Cox and Arjan VdV would like
> > to see this work on it's way to Linus's tree.
> 
> That's because that is the policy of your distro you are working with,
> which has nothing to do with the kernel developers.
> 
> Again, if you get your driver accepted, I have no objection to this
> export at all.  Just take the time and get your driver merged, it's that
> simple.

So I guess the best route is for me to make this patch with my driver
then?  I'm ready to re-submit those drivers again; I cleaned up all the
style issues pointed out by Randy.

> 
> thanks,
> 
> greg k-h


