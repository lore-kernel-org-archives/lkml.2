Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0IDMjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:39:41 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29683 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0IDMjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:39:40 -0400
Date: Sat, 4 Sep 2010 14:39:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>,
        Huaxu Wan <huaxu.wan@intel.com>
Subject: Re: [lm-sensors] [PATCH] drivers/hwmon/coretemp: Remove warnings 
 of unused variables
Message-ID: <20100904143911.4461f918@hyperion.delvare>
In-Reply-To: <20100819215124.GA8097@ericsson.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
	<1282172027-640-2-git-send-email-fenghua.yu@intel.com>
	<20100819092423.00f76256@hyperion.delvare>
	<4C6D8026.2060800@zytor.com>
	<20100819232655.4223e61f@hyperion.delvare>
	<20100819215124.GA8097@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, 19 Aug 2010 14:51:24 -0700, Guenter Roeck wrote:
> On Thu, Aug 19, 2010 at 05:26:55PM -0400, Jean Delvare wrote:
> > On Thu, 19 Aug 2010 12:04:06 -0700, H. Peter Anvin wrote:
> > > Hi Jean,
> > > 
> > > Are you overall hwmon maintainer now?  That job is currently listed as
> > > Orphan in the MAINTAINERS file.
> > 
> > MAINTAINERS is correct. I do not have the time, nor the will, to be the
> > single official maintainer of the hwmon subsystem. I would be happy to
> > be a co-maintainer, but nobody stepped in to co-maintain with me.
>
> I can step in if needed. I don't want to step on anyone's feet, though,
> and I would not want to be the sole maintainer, at least not yet - I just
> don't know the code well enough.

Please don't say this lightly. This is a very serious matter :p

Do you realize how much work this represents? Are you ready to take the
load for a long period of time?

If you are aware that being a subsystem (co-)maintainer can take
several hours per week, and are ready to spend that much time on it for
at least 6 months, then please let me know if you would be OK with the
following:

--- linux-2.6.36-rc3.orig/MAINTAINERS	2010-08-30 08:21:58.000000000 +0200
+++ linux-2.6.36-rc3/MAINTAINERS	2010-09-04 14:38:43.000000000 +0200
@@ -2641,9 +2641,11 @@ S:	Maintained
 F:	drivers/media/video/gspca/
 
 HARDWARE MONITORING
+M:	Jean Delvare <khali@linux-fr.org>
+M:	Guenter Roeck <guenter.roeck@ericsson.com>
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
-S:	Orphan
+S:	Maintained
 F:	Documentation/hwmon/
 F:	drivers/hwmon/
 F:	include/linux/hwmon*.h

I am not working with you for such a long time, but collaboration went
just fine from my perspective, so I would be very happy to co-maintain
the hwmon subsystem with you.

Thanks,
-- 
Jean Delvare
