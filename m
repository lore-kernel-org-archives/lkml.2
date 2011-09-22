Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1IVTnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:43:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36579 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab1IVTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:43:13 -0400
X-Sasl-enc: +Vm+l2ps3/8uuLBWhXUPaE7aS40FhSYwNBA+wFvr20zS 1316720593
Date: Thu, 22 Sep 2011 12:43:10 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922194310.GA8919@kroah.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
 <20110922193805.GA8140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922193805.GA8140@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 12:38:05PM -0700, Greg KH wrote:
> > I personally don't working with distros, but I believe that SUSE has
> > major deployment of iAMT (MEI).  Oren may have more info about it.
> 
> Ah, this one:
> 	https://build.opensuse.org/package/show?package=intel-iamt&project=openSUSE%3A11.4
> If so, that package has been dropped by SUSE as it seems to no longer be
> maintained upstream.  Is this incorrect?
> 
> Care to point to the proper download location for the lms tarball?

No, sorry, I think that tools uses the old, obsolete, heci kernel
driver, and not this "mei" driver, right?

Do you have a pointer to any tools that use this interface for this
driver?

thanks,

greg k-h
