Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0JTTIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:08:05 -0400
Received: from mail.perches.com ([173.55.12.10]:3393 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0JTTID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:08:03 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101020183544.GA22966@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
	 <1287590363.1813.148.camel@Joe-Laptop>
	 <20101020164929.GB22572@ericsson.com>
	 <1287593660.1813.198.camel@Joe-Laptop>
	 <20101020171806.GD22572@ericsson.com>
	 <1287595700.1813.202.camel@Joe-Laptop>
	 <20101020174846.GA22819@ericsson.com>
	 <1287597762.1813.217.camel@Joe-Laptop>
	 <20101020183544.GA22966@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 12:08:00 -0700
Message-ID: <1287601680.15567.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 11:35 -0700, Guenter Roeck wrote:
> My take is that the time to reach such an agreement is now, to avoid cluttering more code
> with pr_fmt defines. The longer we wait, the more difficult it will get to reach an agreement,
> since more and more subsystems will be affected.

I believe after some agreement is reached, the default
will become some equivalent of KBUILD_MODNAME ": "
and the actions required in files that already have
that #define will allow leisurely removal of those
now unnecessary defines.

I expect functions to replace the #defines for
pr_<level> and those functions will emit the
appropriate KBUILD_MODNAME equivalents.



