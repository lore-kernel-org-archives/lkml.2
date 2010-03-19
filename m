Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0CSW4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0CSW4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:56:36 -0400
Date: Fri, 19 Mar 2010 15:56:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Othman, Ossama" <ossama.othman@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Intel Restricted Access Region Handler
Message-ID: <20100319225608.GA13174@suse.de>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
 <20100314181040.GB28359@suse.de>
 <A5FE05C4C76E4C4CAB15D9962B96FC950C9A6D184E@orsmsx510.amr.corp.intel.com>
 <20100315234508.GB4008@suse.de>
 <20100319143222.72aee474.akpm@linux-foundation.org>
 <A5FE05C4C76E4C4CAB15D9962B96FC950C9A7A6431@orsmsx510.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5FE05C4C76E4C4CAB15D9962B96FC950C9A7A6431@orsmsx510.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 03:53:07PM -0700, Othman, Ossama wrote:
> Andrew, Greg,
> 
> > Regarding the code itself: it appears to implement a userspace
> > interface via some /dev node.  But there is no description of this
> > interface at all in the changelog and there is no documentation
> > provided.  But the userspace-facing interface is the most important
> > part of the entire feature, because it is something we cannot ever
> > change.  It should be exhaustively described right up-front in the
> > changelog so that reviewers can easily and fully understand the
> > proposed API.
> 
> Would a README file of some sort be suitable to describe the driver
> interface or should I just embed additional documentation in the
> driver's interface header?

You are going to have to create a Documentation/ABI/ style file
eventually, so you might as well do it now and add it to the driver
directory.

thanks,

greg k-h
