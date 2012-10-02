Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2JBCy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:54:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51839 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2JBCy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:54:28 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Oct 2012 19:55:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v2 1/2] hwmon: (ads7828) driver cleanup
Message-ID: <20121002025504.GA3108@roeck-us.net>
References: <1349133384-5181-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20121002010705.GB2437@roeck-us.net>
 <1349144167.5876.13.camel@trivette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349144167.5876.13.camel@trivette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:16:07PM -0400, Vivien Didelot wrote:
> Hi Guenter,
> 
[ ... ]
> > >  
> > > -/* Each client has this additional data */
> > > +/**
> > > + * struct ads7828_data - client specific data
> > > + * @hwmon_dev:		The hwmon device.
> > > + * @update_lock:	Mutex protecting updates.
> > > + * @valid:		Validity flag.
> > > + * @last_updated:	Last updated time (in jiffies).
> > > + * @adc_input:		ADS7828_NCH samples.
> > > + */
> > This isn't really an externally visible API, so I wonder if it provides value to
> > document it this way. No strong opinion, just wondering.
> I found the version below a bit cluttered, that's why I used the
> KernelDoc notation. Would you prefer something else, like right-aligned
> comments?

Tab aligned, maybe ? Not sure if that works out, though.

Guenter
