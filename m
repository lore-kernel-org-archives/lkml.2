Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab1CRWiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:38:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:51833 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab1CRWiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:38:10 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: andy.green@linaro.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D82979B.2050003@linaro.org>
References: <20110311165642.GA9996@kroah.com>
	 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
	 <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de>
	 <4D82979B.2050003@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 09:37:43 +1100
Message-ID: <1300487863.22236.1289.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 23:22 +0000, Andy Green wrote:
> 
> Is there actually a need for sort of not platform_data but universal 
> vid_pid_specific_usb_device_option_data coming from the board
> definition 
> file or bootloader for *pluggable* usb devices?  udev seems to be
> well 
> established doing that already in a generic, not-platform-specific
> way 
> that can go in all distros and so on nicely.  Maybe this is just my 
> impoverished imagination and people do want, say, some kinds of USB
> mice 
> to operate at higher DPI or whatever when plugged in a specific board 
> because it is that board. 

Except that vid/pid are the -WRONG- way to do that. Your device is
on-board, the proper way to identify it uniquely is it's topological
location, ie path of HW port numbers.

Cheers,
Ben.


