Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2EJOsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:48:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57385 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755867Ab2EJOsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:48:15 -0400
Date: Thu, 10 May 2012 10:48:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <ming.m.lin@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device
 power off policy
In-Reply-To: <1336611349.6190.245.camel@yhuang-dev>
Message-ID: <Pine.LNX.4.44L0.1205101046010.1831-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012, Huang Ying wrote:

> How to remove power is not general enough, but I think whether to power
> off is more general.  So a flag like power_must_be_on can be general and
> useful.

I'm not so sure about that.

> > Also, from a driver's perspective the result of putting a device into
> > some non-power-off low-power state may be just as unpleasant as the
> > result of removing power from it.
> 
> Yes.  From device driver or bus point of view, "power off" is just like
> other low power state.  But from the "all devices" point of view, power
> off can be the only low power state that is shared by all devices.  So
> we can say "power off" is special from this point of view.

No -- it's not true that all devices share a "power off" state while 
the system is running.

The only thing that can be said about all devices is that some of them 
can be put into one or many low-power states.  That's what the PM core 
means when it talks about runtime suspend.

Alan Stern

