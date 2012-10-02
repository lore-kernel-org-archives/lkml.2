Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2JBEey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:34:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54130 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2JBEeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:34:23 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Oct 2012 21:35:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org,
        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v2 2/2] hwmon: (ads7828) add support for ADS7830
Message-ID: <20121002043500.GA3247@roeck-us.net>
References: <1349133384-5181-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1349133384-5181-2-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20121002012007.GC2437@roeck-us.net>
 <1349148501.5876.22.camel@trivette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349148501.5876.22.camel@trivette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 11:28:21PM -0400, Vivien Didelot wrote:
> Hi Guenter,
> 
Hi Vivien,

[ ... ]

> > > +			} else {
> > > +				dev_dbg(&client->dev, "doesn't look like an "
> > > +					"ADS7828 compatible device\n");
> > 
> > WARNING: quoted string split across lines
> > #190: FILE: drivers/hwmon/ads7828.c:196:
> > +                               dev_dbg(&client->dev, "doesn't look like an "
> > +                                       "ADS7828 compatible device\n");
> Hum ok, so the reason for that is that it breaks the ability to grep a
> string... Makes sense.
> > 
> > Better:
> > 				dev_dbg(&client->dev,
> > 					"doesn't look like an ADS7828 compatible device\n");
> This exceeds 80 chars, but I'll find a shorter message.

That is ok nowadays if it is due to a quoted string.

Guenter 
