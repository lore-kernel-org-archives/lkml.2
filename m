Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1CKTjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:39:08 -0500
Received: from kroah.org ([198.145.64.141]:46974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1CKTi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:38:58 -0500
Date: Fri, 11 Mar 2011 11:37:10 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311193710.GD14204@kroah.com>
References: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
 <4D7A5329.6080507@linaro.org>
 <20110311170807.GA10350@kroah.com>
 <4D7A654F.7010709@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A654F.7010709@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 06:09:19PM +0000, Andy Green wrote:
> >Also, do you have a real example of a USB driver today that needs this?
> 
> I think you find without devpath -> platform_data mapping, the kind
> of layout given above is made quite difficult to support in Linux.

So you have devices today that you can not support in Linux because of
this problem?  Please provide us specifics about them and we will gladly
work to solve this.  But without such information, hand-waving is going
to get you nowhere.

> Saying, "oh go away and do it in userspace" actually means special
> scripts that grep /proc/cpuinfo to reproduce the knowledge inherent
> already in the board definition file, although it's out of your hair
> nicely, it leaves me feeling we reached an overall solution that is
> "less good than it should be".

I'm saying "do network device naming in userspace" as that is where it
belongs.

If you have other type of configuration you need to do, again, provide
us specifics please and we will be glad to work on the proper solution.

thanks,

greg k-h
