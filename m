Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0DCHXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 03:23:47 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51878 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0DCHXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 03:23:44 -0400
Date: Sat, 3 Apr 2010 09:23:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking00@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v2] hwmon: driver for TI tmp102 temperature
  sensor
Message-ID: <20100403092340.52862542@hyperion.delvare>
In-Reply-To: <20100315135217.550a6aba@hyperion.delvare>
References: <201003132000.35840.sfking00@yahoo.com>
	<20100315135217.550a6aba@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Mon, 15 Mar 2010 13:52:17 +0100, Jean Delvare wrote:
> Hi Steven,
> 
> On Sat, 13 Mar 2010 20:00:35 -0800, Steven King wrote:
> > Driver for the TI TMP102.
> > 
> > Signed-off-by: Steven King <sfking@fdwdc.com>
> > ---
> > 
> > The TI TMP102 is similar to the lm75.  It differs from the lm75 by having a 16
> > bit conf register and the temp registers have a minimum resolution of 12bits;
> > the extended conf register can select 13 bit resolution (which this driver
> > does) and also change the update rate (which this driver currently doesn't
> > use).
> > 
> > V2: removed broken and unneeded detection routine,
> >     made temperature conversion use base 1000 instead of base 100.
> >     (per Jean Delvare's feed back)
> >     incorporated fixes for the loop and made dev_pm_ops const.
> >     (per Andrew Morton's patch)
> > 
> >  Documentation/hwmon/tmp102 |   27 ++++
> >  drivers/hwmon/Kconfig      |   10 ++
> >  drivers/hwmon/Makefile     |    1 +
> >  drivers/hwmon/tmp102.c     |  296 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 334 insertions(+), 0 deletions(-)
> 
> Here's my review. Feel free to pick whatever you like in it and ignore
> the rest. Then submit a final version for upstream integration.

Any update? Would be great to not lose all the work that both you and
me put in this driver so far.

-- 
Jean Delvare
