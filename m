Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1BQULC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:11:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:10108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1BQULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:11:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,182,1297065600"; 
   d="scan'208";a="709165883"
Subject: Re: [PATCH 09/12] n_tracesink header file.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <20110217195400.GB12172@kroah.com>
References: <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192300.GD29448@kroah.com> <1297971915.3038.32.camel@localhost>
	 <20110217195400.GB12172@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Feb 2011 12:10:47 -0800
Message-ID: <1297973447.3038.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:54 -0800, Greg KH wrote:
> On Thu, Feb 17, 2011 at 11:45:15AM -0800, J Freyensee wrote:
> > On Thu, 2011-02-17 at 11:23 -0800, Greg KH wrote:
> > > On Tue, Feb 08, 2011 at 11:34:54AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > 
> > > > This header file allows the n_tracerouter to send it's information
> > > > to the n_tracesink ldisc driver.  It's part of the Intel-Atom
> > > > PTI implementation solution.
> > > > 
> > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > ---
> > > >  include/linux/n_tracesink.h |   32 ++++++++++++++++++++++++++++++++
> > > 
> > > Why is this in include/linux/ ?
> > > 
> > 
> > I thought this was the best place to stick this .h file.  I'd be happy
> > to change locations based off of your suggestion.
> 
> Why do you need a .h file at all?  Who is using it?

The only current module that really uses it is n_tracerouter; however, I
thought sticking this in a .h file made things slightly more modular and
more re-usable, especially for future device driver writers that could
want something like this.

If you would like me to remove this though, I can, just let me know.
Thanks.

> 
> thanks,
> 
> greg k-h


