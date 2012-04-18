Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2DRTFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:05:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2DRTFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:05:08 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 15:05:07 EDT
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH v2 0/9] PM: Create the AVS class of drivers
Date: Wed, 18 Apr 2012 20:49:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: jean.pihet@newoldbits.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <878vhski53.fsf@ti.com>
In-Reply-To: <878vhski53.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204182049.53212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 18, 2012, Kevin Hilman wrote:
> Rafael,
> 
> jean.pihet@newoldbits.com writes:
> 
> > From: Jean Pihet <j-pihet@ti.com>
> >
> > AVS is a power management technique which controls the operating
> > voltage of a device in order to optimize (i.e. reduce) its power
> > consumption. The voltage is adapted depending on static factors
> > (chip manufacturing process) and dynamic factors (temperature
> > depending performance).
> > AVS is also called SmartReflex on OMAP devices.
> >
> > To that end, create the AVS framework in drivers/power/avs and
> > move the OMAP SmartReflex code to the new directory.
> 
> I've done a review of this series and had a few very minor comments.
> 
> Once those are addressed, are you OK with us moving this AVS driver
> under drivers/power?

Yes, I am.

Thanks,
Rafael
