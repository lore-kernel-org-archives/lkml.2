Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0IMQzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:55:52 -0400
Received: from imr3.ericy.com ([198.24.6.13]:37343 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0IMQzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:55:51 -0400
Date: Mon, 13 Sep 2010 09:54:22 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] hwmon: Add tempX_emergency_alarm attribute to
 sysfs ABI
Message-ID: <20100913165422.GA1092@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
 <1284038750-8833-2-git-send-email-guenter.roeck@ericsson.com>
 <20100913181718.56ba6054@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100913181718.56ba6054@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:17:18PM -0400, Jean Delvare wrote:
> On Thu, 9 Sep 2010 06:25:44 -0700, Guenter Roeck wrote:
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> >  Documentation/hwmon/sysfs-interface |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > index 101300b..22843cb 100644
> > --- a/Documentation/hwmon/sysfs-interface
> > +++ b/Documentation/hwmon/sysfs-interface
> > @@ -513,6 +513,7 @@ fan[1-*]_max_alarm
> >  temp[1-*]_min_alarm
> >  temp[1-*]_max_alarm
> >  temp[1-*]_crit_alarm
> > +temp[1-*]_emergency_alarm
> >  		Limit alarm
> >  		0: no alarm
> >  		1: alarm
> 
> Looks good, I'll merge this into the following patch:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-add-tempx_emergency-attribute-to-sysfs-abi.patch
> 
> as they make more sense together than separated.
> 
Agreed.

Guenter
