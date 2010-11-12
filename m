Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0KLWAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:00:39 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60381 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753527Ab0KLWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:00:35 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 17:00:35 EST
MIME-Version: 1.0
In-Reply-To: <1289594026.22931.388.camel@groeck-laptop>
References: <1289594026.22931.388.camel@groeck-laptop>
Date: Fri, 12 Nov 2010 13:53:50 -0800
Message-ID: <AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
Subject: Re: [lm-sensors] Location for thermal drivers
From: Phil Pokorny <ppokorny@penguincomputing.com>
To: guenter.roeck@ericsson.com
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 12:33 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> I think a better location for the driver would be drivers/thermal.
> drivers/hwmon is not really a good fit, since hwmon support for thermal
> drivers is optional. Potential problem with drivers/thermal is that
> there are no thermal drivers in there (yet), and there does not seem to
> be a maintainer.

What is the difference between a "thermal" sensor and a "temperature"
sensor?  Aren't they the same thing?

Why does drivers/thermal exist if there are no drivers in it and no maintainer?

Phil P.
