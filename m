Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1DFHdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:33:12 -0400
Received: from imr3.ericy.com ([198.24.6.13]:57645 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab1DFHdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:33:11 -0400
Date: Wed, 6 Apr 2011 00:32:22 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "achew@nvidia.com" <achew@nvidia.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "w30289@motorola.com" <w30289@motorola.com>,
        "toddpoynor@google.com" <toddpoynor@google.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "olofj@chromium.org" <olofj@chromium.org>
Subject: Re: [PATCH 1/1] [hwmon] nct1008: Initial NCT1008 driver
Message-ID: <20110406073222.GD23562@ericsson.com>
References: <1302059183-29631-1-git-send-email-achew@nvidia.com>
 <20110406092358.07e8ca78@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110406092358.07e8ca78@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Apr 06, 2011 at 03:23:58AM -0400, Jean Delvare wrote:
> Hi Andrew,
> 
[ ... ]
> > +
> > +/* Register Addresses */
> > +#define LOCAL_TEMP_RD			0x00
> > +#define EXT_HI_TEMP_RD			0x01
> > +#define EXT_LO_TEMP_RD			0x10
> > +#define STATUS_RD			0x02
> > +#define CONFIG_RD			0x03
> > +
> > +#define CONFIG_WR			0x09
> > +#define CONV_RATE_WR			0x0A
> > +#define LOCAL_TEMP_HI_LIMIT_WR		0x0B
> > +#define EXT_TEMP_HI_LIMIT_HI_BYTE	0x0D
> > +#define OFFSET_WR			0x11
> > +#define EXT_THERM_LIMIT_WR		0x19
> > +#define LOCAL_THERM_LIMIT_WR		0x20
> > +#define THERM_HYSTERESIS_WR		0x21
> 
> These register definitions look very familiar to me. Have you looked at
> the lm90 driver to check has difficult it would be to add support for
> the NCT1008? I bet it will only take a few lines of code.
> 
After I spent a couple of hours reviewing the driver, I noticed that the chip is functionally
identical to ADT7461A (the only difference is the package; even the chip ID is the same),
and the ADT7461A is in turn functionally identical to ADT7461. Sigh :(.

Guenter
