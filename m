Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0IIFB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:01:59 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:37815 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab0IIFBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:01:55 -0400
Date: Thu, 9 Sep 2010 15:01:37 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100909050137.GR14056@atomos.longlandclan.yi.org>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
 <4C884AFA.20604@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C884AFA.20604@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 02:48:26PM +1200, Ryan Mallon wrote:
> On 09/09/2010 12:02 PM, Stuart Longland wrote:
> > How are voltage *monitors* normally written?  (note, not voltage
> > *regulators*... this thing does not alter the voltage rails.)  I tried
> > to make sense of lm-sensors, but that seems very ad-hoc (maybe I missed
> > some document that explains it) to me.  It's hard to be clear on what is
> > the *right* way to report a voltage or current reading to userspace.
> 
> Depending on your particular application it might make sense to use the
> power supply class (see Documentation/power/power_supply_class.txt) for
> the voltage/current monitoring. If the temperature sensor is related to
> a power supply monitor, then it could also go there.

Ahh okay, I'll have a look there..  The temperature isn't related to the
power supply, so I might continue a searchfor its rightful place, but
that class of devices seems like a good fit.
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
