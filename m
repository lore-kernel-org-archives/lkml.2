Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0KKOY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:24:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:18465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab0KKOYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,183,1288594800"; 
   d="scan'208";a="676527534"
From: "Lighthart, EricX" <ericx.lighthart@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "pb@handhelds.org" <pb@handhelds.org>,
        "ext-mika.1.westerberg@nokia.com" <ext-mika.1.westerberg@nokia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Nov 2010 06:24:21 -0800
Subject: RE: [PATCH] input: Add sysfs interface to on/off state of GPIO	keys
 and switches
Thread-Topic: [PATCH] input: Add sysfs interface to on/off state of GPIO
	keys and switches
Thread-Index: AcuBqvHqZTo7AEsZQcC+EUyCntFghwAAO2Mg
Message-ID: <E559D19195578B4E9ECB3919FF99F9792A585A8BBC@orsmsx509.amr.corp.intel.com>
References: <E559D19195578B4E9ECB3919FF99F9792A585A8BB1@orsmsx509.amr.corp.intel.com>
 <20101111141545.GB5043@sirena.org.uk>
In-Reply-To: <20101111141545.GB5043@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's the already-existing solution I was looking for.
Thanks Mark.

Dmitry, et al, please withdraw the patch.

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, November 11, 2010 6:16 AM
> To: Lighthart, EricX
> Cc: dmitry.torokhov@gmail.com; pb@handhelds.org; ext-
> mika.1.westerberg@nokia.com; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] input: Add sysfs interface to on/off state of GPIO
> keys and switches
> 
> On Thu, Nov 11, 2010 at 06:03:35AM -0800, Lighthart, EricX wrote:
> > User space cannot learn the current state of a GPIO key or switch.
> > Input system reports only changes, not state.
> >
> > Add two sysfs attributes, one each for keys and switches, that
> > report lists of keys or switches currently "on."
> 
> There's EVIOCG* ioctl()s for this.  Something sysfs (or a widely
> distributed utility) would be very helpful but there is actually a
> facility to read the state.
> 
> >  drivers/input/keyboard/gpio_keys.c |   68
> ++++++++++++++++++++++++++++--------
> 
> If something is needed here it should be done as part of the input
> layer, not in a driver specific fashion - there's nothing specific to
> GPIO keys here.
