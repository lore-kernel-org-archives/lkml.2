Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1IZPBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:01:15 -0400
Received: from imr4.ericy.com ([198.24.6.9]:54334 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1IZPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:01:14 -0400
Subject: Re: [lm-sensors] CONFIG_THERMAL_HWMON configuration option removal
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
In-Reply-To: <20110926103255.02db677c@endymion.delvare>
References: <20110926033740.GA5637@ericsson.com>
	 <20110926103255.02db677c@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 26 Sep 2011 07:59:31 -0700
Message-ID: <1317049171.3888.49.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 04:32 -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Sun, 25 Sep 2011 20:37:40 -0700, Guenter Roeck wrote:
> > I just noticed the folllowing in feature-removal-schedule.txt:
> > 
> > What:   CONFIG_THERMAL_HWMON
> > When:   January 2009
> > Why:    This option was introduced just to allow older lm-sensors userspace
> >         to keep working over the upgrade to 2.6.26. At the scheduled time of
> >         removal fixed lm-sensors (2.x or 3.x) should be readily available.
> > Who:    Rene Herman <rene.herman@gmail.com>
> > 
> > I don't know what the lm-sensors changes are, and if they have been implemented.
> > Is it time to remove the configuration option ?
> 
> Not sure where you looked, but it's already gone. See commit
> ab92402af04c151c26541eb28e1c26286a429db5.
> 
Ah yes, now I remember. No idea what I looked at. Should teach me to
clean up my branches.

Sorry for the noise.

Guenter


