Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1CQVPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:15:05 -0400
Received: from kroah.org ([198.145.64.141]:40692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1CQVPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:15:00 -0400
Date: Thu, 17 Mar 2011 13:26:14 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317202614.GA3155@kroah.com>
References: <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
 <20110317201320.GB4035@kroah.com>
 <20110317201835.GM31411@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317201835.GM31411@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 08:18:35PM +0000, Mark Brown wrote:
> On Thu, Mar 17, 2011 at 01:13:20PM -0700, Greg KH wrote:
> > On Wed, Mar 16, 2011 at 10:14:01PM -0400, Nicolas Pitre wrote:
> 
> > > PandaBoards are becoming quite popular.
> 
> > I have one right here.
> 
> > But can't this device be detected by the usb device id and the quirk
> > added that way?  Like all other "odd" USB devices are currently handled?
> 
> It's going to be an off the shelf USB ethernet controller.  I'd be
> astonished if the board-configurable device IDs weren't set from the
> same SEPROM that the MAC address is so it'd just show up as a generic
> chip of whatever kind.

Huh?  All USB controllers you buy have the ability to set the vendor and
product id, so you should always be able to key off of that.

Isn't that the case here?

thanks,

greg k-h
