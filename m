Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0EQMUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:20:23 -0400
Received: from poutre.nerim.net ([62.4.16.124]:53412 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0EQMUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:20:21 -0400
Date: Mon, 17 May 2010 14:20:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking@fdwdc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v2] hwmon: driver for TI tmp102 temperature
 sensor
Message-ID: <20100517142019.36f392ad@hyperion.delvare>
In-Reply-To: <201005050831.56526.sfking@fdwdc.com>
References: <201003132000.35840.sfking00@yahoo.com>
	<20100403092340.52862542@hyperion.delvare>
	<20100504113655.42623e51@hyperion.delvare>
	<201005050831.56526.sfking@fdwdc.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, 5 May 2010 08:31:55 -0700, Steven King wrote:
> On Tuesday 04 May 2010 2:36:55 Jean Delvare wrote:
> > Steven,
> >
> > On Sat, 3 Apr 2010 09:23:40 +0200, Jean Delvare wrote:
> > > Any update? Would be great to not lose all the work that both you and
> > > me put in this driver so far.
> >
> > If you do not reply, I will do all the suggested changes myself and
> > push the driver upstream.
> 
> I'm in the midst of the old '12 hours a day 'til we get this thing off to 
> manufacturing' so I havent had time to do more than a cursory look at your 
> changes and probably wont for a while longer.  Other than a few minor style 
> issues, I didnt see anything I'd take issue with, so if thats what you think is 
> the right thing to do, then please do.

OK, I've written 3 patches applying on top of your work and addressing
most of the issues I had commented on. I'll post them to the list now.
I wasn't able to test them as I don't have a TMP102 chip here, so I
would appreciate if you could review the patches and/or test them as
your time permits.

-- 
Jean Delvare
