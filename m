Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1IVTtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:49:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:47946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1IVTtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,424,1312182000"; 
   d="scan'208";a="53849295"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <greg@kroah.com>
CC: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Sep 2011 22:48:52 +0300
Subject: RE: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Topic: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Index: Acx5X+UkOqGovBcYROC8GSXZjDFTPQAACXnQ
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33A3@hasmsx504.ger.corp.intel.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
 <20110922193805.GA8140@kroah.com> <20110922194310.GA8919@kroah.com>
In-Reply-To: <20110922194310.GA8919@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 22, 2011 10:43 PM
> To: Winkler, Tomas
> Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> 
> On Thu, Sep 22, 2011 at 12:38:05PM -0700, Greg KH wrote:
> > > I personally don't working with distros, but I believe that SUSE has
> > > major deployment of iAMT (MEI).  Oren may have more info about it.
> >
> > Ah, this one:
> >
> > https://build.opensuse.org/package/show?package=intel-
> iamt&project=ope
> > nSUSE%3A11.4 If so, that package has been dropped by SUSE as it seems
> > to no longer be maintained upstream.  Is this incorrect?
> >
> > Care to point to the proper download location for the lms tarball?
> 
> No, sorry, I think that tools uses the old, obsolete, heci kernel driver, and not
> this "mei" driver, right?
> 
> Do you have a pointer to any tools that use this interface for this driver?

Please start here
http://software.intel.com/en-us/blogs/2011/06/01/new-updated-intelr-amt-linux-drivers/
There are no direct download links I can provide. I think this was packaged by SUSE and not by openSUSE, but we really need wait for Oren to answer that.

Tomas

> 
> thanks,
> 
> greg k-h
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

