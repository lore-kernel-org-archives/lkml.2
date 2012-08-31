Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2HaKGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:06:12 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:44325 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2HaKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:06:10 -0400
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <lm-sensors@lm-sensors.org>, <linux-input@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "Wim Van Sebroeck" <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
References: <201208241450@sw-eng-lt-dc-vm2>
 <201208241455@sw-eng-lt-dc-vm2>
 <20120825151020.GB6520@opensource.wolfsonmicro.com>
 <201208291550@sw-eng-lt-dc-vm2>
 <20120830174738.GH4356@opensource.wolfsonmicro.com>
In-Reply-To: <20120830174738.GH4356@opensource.wolfsonmicro.com>
Message-ID: <201208311100@sw-eng-lt-dc-vm2>
Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators support.
Date: Fri, 31 Aug 2012 11:00:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 29, 2012 at 03:50:00PM +0100, Krystian Garbaciak wrote:
> 
> > Because, for some regulators, this is required: val += fvol->offset,
> > I was only able to reduce it to the following form.
> 
> What on earth makes you say this?  The above is obviously linear.
> 
> Besides, you're missing several points here.  One is that you should be
> using the framework features, another is that you should be implementing
> _sel.

Sorry, I've missed an obvious thing here. Instead of adding selector offset at
runtime, I can substract apropriate voltage from .min_uV. Thanks for pointing
this out.

