Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0IXPRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:17:35 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43351 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0IXPRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:17:35 -0400
Date: Fri, 24 Sep 2010 08:16:34 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
Message-ID: <20100924151634.GB18153@ericsson.com>
References: <s5heiclngqe.wl%tiwai@suse.de>
 <20100924135802.GA18109@ericsson.com>
 <s5hlj6r1b5p.wl%tiwai@suse.de>
 <20100924163005.7704f63e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100924163005.7704f63e@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:30:05AM -0400, Jean Delvare wrote:
> On Fri, 24 Sep 2010 16:14:26 +0200, Takashi Iwai wrote:
> > At Fri, 24 Sep 2010 06:58:02 -0700,
> > Guenter Roeck wrote:
> > > 
> > > On Thu, Sep 23, 2010 at 01:58:33AM -0400, Takashi Iwai wrote:
> > > > The recent addition of threaded irq handler causes a NULL dereference
> > > > when used with hp_accel driver, which has NULL pdata.
> > > > 
> > > > Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> > > > Acked-by: Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > > Cc: <stable@kernel.org>
> > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > 
> > > Applied.
> > 
> > Oh, does this driver belong to hwmon tree?
> > Jean told me that this isn't managed in hwmon, so I had an impression
> > that it's an orphan driver.
> 
> Well, as long as the driver lives in drivers/hwmon and the hwmon
> subsystem is maintained, it seems fair to consider the driver
> maintained.
> 
I absolutely second that. Otherwise things would get too complicated.

Guenter
