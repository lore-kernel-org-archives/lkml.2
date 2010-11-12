Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab0KLWHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:07:39 -0500
Received: from imr4.ericy.com ([198.24.6.8]:43331 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0KLWHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:07:35 -0500
Subject: Re: [lm-sensors] Location for thermal drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Phil Pokorny <ppokorny@penguincomputing.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
References: <1289594026.22931.388.camel@groeck-laptop>
	 <AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 12 Nov 2010 14:06:40 -0800
Message-ID: <1289599600.22931.406.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:53 -0500, Phil Pokorny wrote:
> On Fri, Nov 12, 2010 at 12:33 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > I think a better location for the driver would be drivers/thermal.
> > drivers/hwmon is not really a good fit, since hwmon support for thermal
> > drivers is optional. Potential problem with drivers/thermal is that
> > there are no thermal drivers in there (yet), and there does not seem to
> > be a maintainer.
> 
> What is the difference between a "thermal" sensor and a "temperature"
> sensor?  Aren't they the same thing?
> 
The thermal framework is much more extensive than the hwmon framework.
See Documentation/thermal/sysfs-api.txt for details.

> Why does drivers/thermal exist if there are no drivers in it and no maintainer?
> 
The framework resides there. Drivers supporting it are in various
platform directories.

As for why there are no drivers - only the framework - in
drivers/thermal, and why there is no maintainer - no idea.

Guenter


