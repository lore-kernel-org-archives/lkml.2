Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0CaOdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:33:39 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47992 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770Ab0CaOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:33:38 -0400
Date: Wed, 31 Mar 2010 16:33:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "L. Alberto Gim?nez" <agimenez@sysvalve.es>
Cc: Greg KH <gregkh@suse.de>, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, alan@linux.intel.com
Subject: Re: [PATCH] Staging: Add new driver ipheth
Message-ID: <20100331143326.GA1843@ucw.cz>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1269984864-28159-2-git-send-email-agimenez@sysvalve.es> <20100330214509.GA1388@suse.de> <4BB273FE.8010004@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB273FE.8010004@sysvalve.es>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-30 23:58:22, "L. Alberto Gim?nez" wrote:
> On 03/30/2010 11:45 PM, Greg KH wrote:
> > On Tue, Mar 30, 2010 at 11:34:24PM +0200, L. Alberto Gim??nez wrote:
> >> Add new driver to use tethering with an iPhone device to the staging tree.

Does it work out of the box, or is it some kind of driver for
jailbroken iphones?

> > Why the staging tree?
> > 
> > What is wrong with the driver that it needs to go there and not to the
> > main kernel tree?
> > 
> 
> Sorry, I thought that the first step was getting into staging. I ignored
> the fact that it needed a TODO file. I'm not either sure about where
> should it go since it uses the USB interface but in fact is used as a
> network device (drivers/net? drivers/usb?). My guess is drivers/net, but
> I'm pretty sure I'm wrong :)

drivers/net/usb seems like a place.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
