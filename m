Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0IBSQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:16:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23555 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0IBSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:16:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53045029"
Date: Thu, 2 Sep 2010 11:16:50 -0700
From: David Brown <davidb@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/4] platform: Use drv->driver.bus instead of assuming
 platform_bus_type
Message-ID: <20100902181650.GA2589@huya.qualcomm.com>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
 <1282158943-11902-2-git-send-email-ppannuto@codeaurora.org>
 <20100818194410.GA17421@suse.de>
 <4C6C3A28.8070108@codeaurora.org>
 <20100901223442.GA11761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901223442.GA11761@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 03:34:43PM -0700, Greg KH wrote:
> On Wed, Aug 18, 2010 at 12:53:12PM -0700, Patrick Pannuto wrote:
> > On 08/18/2010 12:44 PM, Greg KH wrote:
> > > On Wed, Aug 18, 2010 at 12:15:40PM -0700, Patrick Pannuto wrote:
> > >> In theory (although not *yet* in practice), a driver being passed
> > >> to platform_driver_probe might have driver.bus set to something
> > >> other than platform_bus_type. Locking drv->driver.bus is always
> > >> correct.
> > >>
> > >> Change-Id: Ib015c35237eb5493d17a812576a3a9906e1344d4
> > > 
> > > What is that field?  Why did you add it?
> > > 
> > > confused,
> > > 
> > > greg k-h
> > 
> > Ugh... It's from gerrit; forgot to remove them, sorry.
> > 
> > Do you want a fresh set, or can you just ignore them for now?
> 
> Actually, can I get a fresh set now, as others have commented already.

I'm going to need to take over these patches for Pat.  Give me a
little while to track down the correct versions and I can send them
out.

Thanks,
David

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
