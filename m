Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0FJXUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:20:48 -0400
Received: from kroah.org ([198.145.64.141]:40543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab0FJXUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:20:47 -0400
Date: Thu, 10 Jun 2010 16:19:19 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@canonical.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jiri Slaby <jslaby@suse.cz>,
       linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
Message-ID: <20100610231919.GA21669@kroah.com>
References: <4C0774C6.4090000@suse.cz>
 <20100608143739.192a94cd@virtuousgeek.org>
 <20100610223436.GE8257@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610223436.GE8257@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 04:34:36PM -0600, Alex Chiang wrote:
> But I seriously think it's just time to rip this driver out of
> the tree. If anyone is actually using this driver to do hotplug,
> I will personally buy that person a full half-barrel of
> Colorado's finest microbrew of choice in order to numb the pain
> of making poor career decisions. Hell, we can drink it together,
> during which time I'll hack on the driver. The code surely can't
> get any worse.

A real user found this problem on their machine, so you might have to go
buy that barrel.  Jiri has more details on that :)

Me, I gave the machine that had this hardware in it to osuosl.org a long
time ago, odds are, it's still being used by some group.

thanks,

greg k-h
