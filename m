Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0GFHVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:21:15 -0400
Received: from poutre.nerim.net ([62.4.16.124]:53927 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0GFHVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:21:13 -0400
Date: Tue, 6 Jul 2010 09:21:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, Crane Cai <crane.cai@amd.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH/RFC v2 4/4] hwmon: sysfs API updates
Message-ID: <20100706092109.776c4779@hyperion.delvare>
In-Reply-To: <20100705213953.GA27095@ericsson.com>
References: <1278303018-22069-1-git-send-email-guenter.roeck@ericsson.com>
	<1278303018-22069-5-git-send-email-guenter.roeck@ericsson.com>
	<20100705091857.77ce0077@hyperion.delvare>
	<20100705213953.GA27095@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jul 2010 14:39:53 -0700, Guenter Roeck wrote:
> Hi Jean,
> 
> I noticed I did not copy the list with my reply, so here are are again,
> with a couple of additional comments.
> 
> On Mon, Jul 05, 2010 at 03:18:57AM -0400, Jean Delvare wrote:
> > On Sun, 4 Jul 2010 21:10:18 -0700, Guenter Roeck wrote:
> > > @@ -482,10 +501,17 @@ OR
> > >  
> > >  in[0-*]_min_alarm
> > >  in[0-*]_max_alarm
> > > +in[0-*]_lcrit_alarm
> > > +in[0-*]_crit_alarm
> > > +curr[1-*]_lcrit_alarm
> > > +curr[1-*]_crit_alarm
> > 
> > No _min and _max alarm for curr?
> > 
> Oversight. pmbus devices don't support currX_min and currX_min_alarm, only
> currX_lcrit and currX_lcrit_alarm. The ltc4245 driver already supports
> currX_max_alarm, though, so I'll add both for consistency.
> 
> The ltc4245 driver only supports currX_max_alarm, not currX_min_alarm, though.
> Wonder if that should be changed to currX_alarm, to more closely follow the API.
> Let me know and I'll submit a patch if needed.

Both should be defined and supported, and the driver author chooses
what fits his/her chip best.

-- 
Jean Delvare
