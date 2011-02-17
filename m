Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab1BQTpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:45:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:51387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1BQTpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:45:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,182,1297065600"; 
   d="scan'208";a="888590160"
Subject: Re: [PATCH 09/12] n_tracesink header file.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <20110217192300.GD29448@kroah.com>
References: <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192300.GD29448@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Feb 2011 11:45:15 -0800
Message-ID: <1297971915.3038.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:23 -0800, Greg KH wrote:
> On Tue, Feb 08, 2011 at 11:34:54AM -0800, james_p_freyensee@linux.intel.com wrote:
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This header file allows the n_tracerouter to send it's information
> > to the n_tracesink ldisc driver.  It's part of the Intel-Atom
> > PTI implementation solution.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > ---
> >  include/linux/n_tracesink.h |   32 ++++++++++++++++++++++++++++++++
> 
> Why is this in include/linux/ ?
> 

I thought this was the best place to stick this .h file.  I'd be happy
to change locations based off of your suggestion.

Thanks,
jay

> thanks,
> 
> greg k-h


