Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1IVUSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:18:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37688 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab1IVUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:18:09 -0400
X-Sasl-enc: 071IN5QG4LY3NL7rbddzKYmMLt0VNWuiTzL68Ce7VB+G 1316722688
Date: Thu, 22 Sep 2011 13:18:05 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922201805.GA13274@kroah.com>
References: <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
 <20110922193805.GA8140@kroah.com>
 <20110922194310.GA8919@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33A3@hasmsx504.ger.corp.intel.com>
 <20110922195449.GA9433@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33C0@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33C0@hasmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 11:11:38PM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, September 22, 2011 10:55 PM
> > To: Winkler, Tomas
> > Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.

Again, please fix your email client.

> > > Please start here
> > > http://software.intel.com/en-us/blogs/2011/06/01/new-updated-intelr-
> > am
> > > t-linux-drivers/
> > 
> > That's a pointer to the same driver that is already in the kernel tree, right?
> > What am I missing here?
> 
> There is LMS there but I guess this links is more updated, they call it driver but actually it is a user space daemon.
> 
> Anyhow this one should be the latest one http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/?wapkw=%28Linux+AMT%29
> It also provides ACU.

What is "ACU"?

Anyway, we want a good description of just what this driver is exporting
to userspace, and how it is doing it.  That's the important part here,
and is what we need to be able to properly review the code if you wish
to start the process to move out of drivers/staging/

thanks,

greg k-h
