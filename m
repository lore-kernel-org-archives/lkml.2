Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0GKRAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 13:00:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47841 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0GKRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 13:00:38 -0400
X-Greylist: delayed 2300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jul 2010 13:00:38 EDT
Date: Sun, 11 Jul 2010 18:21:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add support for JEDEC JC 42.4 compliant 
 temperature sensors
Message-ID: <20100711182138.132815e4@hyperion.delvare>
In-Reply-To: <20100711161658.GA23927@ericsson.com>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
	<1278862266.1501.59.camel@Joe-Laptop.home>
	<20100711161658.GA23927@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 09:16:58 -0700, Guenter Roeck wrote:
> On Sun, Jul 11, 2010 at 11:31:06AM -0400, Joe Perches wrote:
> > On Sun, 2010-07-11 at 07:53 -0700, Guenter Roeck wrote:
> > > +	for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
> > > +		if (manid == jc42_chips[i].manid
> > > +		    && (devid & jc42_chips[i].devid_mask) ==
> > > +					    jc42_chips[i].devid) {
> > > +			strlcpy(info->type, "jc42", I2C_NAME_SIZE);
> > > +			return 0;
> > > +		}
> > > +	}
> > 
> > Decidedly trivial:
> > 
> > Kernel style seems to prefer having logical tests at
> > end of line rather than start of line.
>
> Ok. Would be nice to have checkpatch.pl complain about it, though,
> if it is a to-be-enforced rule.

Please, not again. This has been discussed before, with the conclusion
that nobody really cares and we don't want to add pointless warnings to
checkpatch.pl, which in the end will just dissuade people from running
the script and/or contributing to the kernel at all.

-- 
Jean Delvare
