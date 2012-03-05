Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2CEVYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:24:47 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52856 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2CEVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:24:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.239.195 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 13:24:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120305212442.GA8908@kroah.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
 <201203051915.45197.arnd@arndb.de>
 <CACxGe6ujqF3st0y5jbWxx=amr534NY3RHdUzmVVdjqt=fJMJmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6ujqF3st0y5jbWxx=amr534NY3RHdUzmVVdjqt=fJMJmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:10:52PM -0700, Grant Likely wrote:
> > I think "deferwq" is not a good name for a global thread: all work queues are
> > there for deferring somehting. How about "deferredprobe"?
> 
> Sure; again for a follow-on patch if Greg is okay with this version.

It looks good to me.

But, we need some documentation somewhere that we can point people to in
order to show how to use this.

Or, as this really is a bus-specific thing, have you converted any
busses to use it?  If so, I'd like to take that patch at the same time,
I'm leary of infrastructure changes without any users.

thanks,

greg k-h
