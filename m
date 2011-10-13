Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1JMPVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:21:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62704 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1JMPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110131029510.2026-100000@iolanthe.rowland.org>
References: <CACVXFVNXyzzJw7UK+OFuDe23voQvyywoP9AvUsV=iPDFPO4fPw@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131029510.2026-100000@iolanthe.rowland.org>
Date: Thu, 13 Oct 2011 23:21:23 +0800
Message-ID: <CACVXFVMoac7psbfO6UdDvNux4c8bQYS4YNUdz1C-o+CiJzyuZA@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrei Warkentin <awarkentin@vmware.com>, Greg KH <greg@kroah.com>,
        Dilan Lee <dilee@nvidia.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 13, 2011 at 10:31 PM, Alan Stern <stern@rowland.harvard.edu>
>> Maybe we should understand the correct model of the ordering constraints
>> for the multiple device dependancies first, could you give a description or
>> some examples about it?
>
> The requirement is that devices must be capable of resuming in the
> order given by dpm_list, and they must be capable of suspending in
> the reverse order.
>
> Therefore if device A can't work unless device B is functional, then B
> must come before A in dpm_list.

If all devices can support async suspend and resume correctly, looks like
the device order given by dpm_list is not needed any longer, doesn't it?


thanks,
-- 
Ming Lei
