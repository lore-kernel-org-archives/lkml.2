Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1BYSjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:39:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:45549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1BYSjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:39:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,226,1297065600"; 
   d="scan'208";a="713338550"
Subject: Re: [PATCH 10/10] n_tracerouter and n_tracesink compile
 configurations.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110225180031.GB17072@kroah.com>
References: <james_p_freyensee@linux.intel.com>
	 <1298570824-26085-11-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110225180031.GB17072@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 25 Feb 2011 10:39:12 -0800
Message-ID: <1298659152.3156.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 10:00 -0800, Greg KH wrote:
> On Thu, Feb 24, 2011 at 10:07:04AM -0800, james_p_freyensee@linux.intel.com wrote:
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This patch allows n_tracerouter and n_tracesink to be compiled and
> > configured in the Linux kernel.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > ---
> >  drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++
> 
> Why drivers/char/Kconfig?  This should be in drivers/tty/Kconfig, right?
> 
> Yes, this is a recent change, see the linux-next tree for the addition
> of this file :)
> 

That is what I was going to ask because I did base this patch off of the
2.6.37 stable tree and did not see a drivers/tty/Kconfig :-O.  I figured
the stable branch was the better choice since you own it and I need to
go through you for my work.

So I should pull from linux-next I guess to fix the changes mentioned
this round?:

-Thomas's comments on Patch 9.
-These issues in this patch

?

Thanks,
jay

> thanks,
> 
> greg k-h


