Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1DMOvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:51:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60294 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1DMOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UKBtnKq5gLP2AiLJ4Z/Gwjf5efx7tJainmFfDZ9651CqcNHVpv6o483k6k5MvvkB6s
         LOSsaS4K13nzwwfcZh2lEUcBX8jKuOYLAofAivYn8LxLicLUKbCUAH5v2LZiOK5sTljI
         T/fNP6WNi5122GwUkga+9byS11n8RuurV7V80=
Date: Wed, 13 Apr 2011 16:51:29 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] hwmon, fam15h_power: Add maintainers entry
Message-ID: <20110413145129.GA4790@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
 <20110406135424.GC2177@alberich.amd.com>
 <20110408135746.GB12014@alberich.amd.com>
 <20110413150855.21542d6e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413150855.21542d6e@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:08:55PM +0200, Jean Delvare wrote:
> Hi Andreas,
> 
> On Fri, 8 Apr 2011 15:57:46 +0200, Andreas Herrmann wrote:
> > From: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  MAINTAINERS |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > As suggested by Jean, here's a patch to add a maintainers
> > entry for the new driver.
> > 
> > 
> > Regards,
> > 
> > Andreas
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6b4b9cd..af8421d 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -483,6 +483,13 @@ F:	drivers/tty/serial/altera_jtaguart.c
> >  F:	include/linux/altera_uart.h
> >  F:	include/linux/altera_jtaguart.h
> >  
> > +AMD FAM15H PROCESSOR POWER HARDWARE MONITORING DRIVER
> 
> I'd remove "HARDWARE" as the target hardware is already described.
> 
> > +M:	Andreas Herrmann <andreas.herrmann3@amd.com>
> > +L:	lm-sensors@lm-sensors.org
> > +S:	Maintained
> > +F:	Documentation/hwmon/fam15h_power
> > +F:	drivers/hwmon/fam15h_power.c
> > +
> >  AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
> >  M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
> >  L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
> 
> Other than this small detail, which I can fix myself if you agree with
> me, this looks good, thanks for stepping in!

I agree.


Thanks,

Andreas
