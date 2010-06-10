Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab0FJX2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:28:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40784 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0FJX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:28:33 -0400
Date: Thu, 10 Jun 2010 17:28:25 -0600
From: Alex Chiang <achiang@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jiri Slaby <jslaby@suse.cz>,
       linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
Message-ID: <20100610232825.GH8257@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jiri Slaby <jslaby@suse.cz>, linux-pci@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>
References: <4C0774C6.4090000@suse.cz>
 <20100608143739.192a94cd@virtuousgeek.org>
 <20100610223436.GE8257@canonical.com>
 <20100610231919.GA21669@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610231919.GA21669@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> On Thu, Jun 10, 2010 at 04:34:36PM -0600, Alex Chiang wrote:
> > But I seriously think it's just time to rip this driver out
> > of the tree. If anyone is actually using this driver to do
> > hotplug, I will personally buy that person a full half-barrel
> > of Colorado's finest microbrew of choice in order to numb the
> > pain of making poor career decisions. Hell, we can drink it
> > together, during which time I'll hack on the driver. The code
> > surely can't get any worse.
> 
> A real user found this problem on their machine, so you might
> have to go buy that barrel.  Jiri has more details on that :)

Well, I went and read the bz before responding, and the user did
say that he wan't interested in the actual hotplug aspect of it.
;)

> Me, I gave the machine that had this hardware in it to
> osuosl.org a long time ago, odds are, it's still being used by
> some group.

Oh, I don't doubt that someone is using the hardware to do
something useful. But I do doubt that anyone's using the hotplug
driver. It's been in various stages of brokenness for several
years now.

/ac
