Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1BQTfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:35:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:23592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BQTfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:35:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,181,1297065600"; 
   d="scan'208";a="603838618"
Subject: Re: [PATCH 04/12] PTI Kconfig change in misc.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <20110217192038.GB29448@kroah.com>
References: <james_p_freyensee@linux.intel.com>
	 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192038.GB29448@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Feb 2011 11:35:51 -0800
Message-ID: <1297971351.3038.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:20 -0800, Greg KH wrote:
> On Tue, Feb 08, 2011 at 11:34:49AM -0800, james_p_freyensee@linux.intel.com wrote:
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This adds the Intel PTI Kconfig option.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > ---
> >  drivers/misc/Kconfig |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 4d073f1..f8076f1 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -136,6 +136,18 @@ config PHANTOM
> >  	  If you choose to build module, its name will be phantom. If unsure,
> >  	  say N here.
> >  
> > +config INTEL_MID_PTI
> 
> Don't add new Kconfig options when there is no code for it yet to use
> it.  Merge this with the Makefile patch.
> 

I do not quite understand the problem.  The code for this Kconfig is
~/drivers/misc/pti.c and it was patch 3/12.  I tested that in 'make
menuconfig' the kernel turns the compile option on and off fine.

What needs to be fixed here?

> thanks,
> 
> greg k-h


