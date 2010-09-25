Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0IYQUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 12:20:52 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43767 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab0IYQUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 12:20:51 -0400
Date: Sat, 25 Sep 2010 09:20:20 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 2.6.36
Message-ID: <20100925162020.GA24697@ericsson.com>
References: <1285378081-7902-1-git-send-email-guenter.roeck@ericsson.com>
 <20100925125644.13f6ab91@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100925125644.13f6ab91@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 06:56:44AM -0400, Jean Delvare wrote:
> On Fri, 24 Sep 2010 18:28:01 -0700, Guenter Roeck wrote:
> > Hi Linus,
> > 
> > Please pull hwmon subsystem fixes for Linux 2.6.36 from:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus
> > 
> > Thanks,
> > Guenter Roeck
> > 
> > ------
> > 
> > Guenter Roeck (1):
> >       MAINTAINERS: Update hwmon entry
> > 
> > Jan Beulich (7):
> >       x86/hwmon: fix module init for hotplug-but-no-device-found case
> >       x86/hwmon: avoid deadlock on CPU removal in pkgtemp
> >       x86/hwmon: don't leak device attribute file from pkgtemp_probe() and pkgtemp_remove()
> >       x86/hwmon: fix initialization of coretemp
> >       x86/hwmon: fix initialization of pkgtemp
> >       x86/hwmon: register alternate sibling upon CPU removal
> >       x86/hwmon: pkgtemp has no dependency on PCI
> > 
> > Takashi Iwai (1):
> >       hwmon: (lis3) Fix Oops with NULL platform data
> 
> Thanks a lot for all the review work, Guenter, I appreciate it a lot! I
> didn't quite expect you to get up to speed so fast!
> 
Only thanks to your and Andrew's help.

Guenter
