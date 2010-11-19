Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0KSTtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:49:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0KSTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:49:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QQe17snB0etUqNyYnWa5MVowoYIXwaTklSGc4LIqXIeNwkO84GVcoXQjwFW3xmSV2z
         D6Su/L8BSiJJ+nuZ8z9DkgIix03IkbSdOzzOjo0LIxCHHX9TyI1IpM44cJtIJVI4WIe/
         v+P2g/jxORu441XWcXP5ndUCJTiv5OBr3uqLQ=
Date: Fri, 19 Nov 2010 20:49:31 +0100
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: wim@iguana.be
Cc: me@mortis.eu, linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/3] watchdog: add f71862fg support
Message-ID: <20101119194931.GA28587@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 14:33 +0200, Wim Van Sebroeck wrote:

> On Sun, Sep 26, 2010 at 04:06:29PM +0200, Lutz Ballaschke wrote:
> > > Furthermore i was thinking about modifying the WDIOC_GETTIMELEFT
> ...
> > and gets 6 minutes returned by ioctl. But imho it's not very accurate to
> > > return a value of seconds if the wdt doesn't count in seconds. That might
> > > be even more confusing. This inconsistency on the part of the hardware 
> > > maybe can't get satisfyingly compensated by the driver. So i'd prefer the 
> > > most simple solution.
> ...
> The return value should be the seconds before the watchdog will reboot.
> So value should be seconds, not minutes and is best the safest value
> (so (minutes - 1) * 60 + 1 in this case ).
> Secondly: the WDIOC_GETTIMELEFT should only be a DEBUGging ioctl.
> The reason I created it, is to check if certain drivers are working
> or not. We should not use it in normal operations imho.
> 
I noticed the patches for f71862fg support in f71808e driver are still
missing in the recent pull request. This might be due to the ioctl
implementation 	(PATCHv3 2/3) mentioned above which wasn't clarified.
Since i missed to reply at your remarks this was my fault. Now i hope
the PATCHv3 1/3 and 3/3 to get through as they already were signed-off
by the author of that driver. Since the patch in question isn't
essential for driver operation i suggest to drop that issue.
Sorry for the inconvenience.

With kind regards,

Lutz Ballaschke

