Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0JTQo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:44:26 -0400
Received: from imr4.ericy.com ([198.24.6.8]:39229 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab0JTQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:44:25 -0400
Date: Wed, 20 Oct 2010 09:43:43 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Joe Perches <joe@perches.com>, Hans de Goede <j.w.r.degoede@hhs.nl>,
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
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020164343.GA22572@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
 <20101020032938.GA20095@ericsson.com>
 <1287545658.10409.606.camel@Joe-Laptop>
 <20101020035346.GA20178@ericsson.com>
 <1287547662.10409.618.camel@Joe-Laptop>
 <20101020093438.07b129c8@endymion.delvare>
 <20101020144608.GA21937@ericsson.com>
 <20101020183835.202989c9@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101020183835.202989c9@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,
On Wed, Oct 20, 2010 at 12:38:35PM -0400, Jean Delvare wrote:
[ ... ]
> 
> I'm still using quilt so it means quite some manual work for me. Probably
> I could automate part of it, and I would if it was happening
> frequently. But as it stands it's rather rare.
> 
I tried quilt, but dumped it in favor of git. Personal preference, maybe,
but I seem to get along with git much better than with quilt.

> OK. Well, only two of "my" drivers are affected by Joe's patch (it87
> and pcf8591), so if you prefer the split variant, you could pick all
> the individual patches except these two, and I take these two.
> 
Ok, let's do that.

> But first of all, I really would like the pr_fmt issue do be sorted
> out. I don't like the idea of having to redefine it in every driver,
> when it seems easy to avoid that. Joe?
> 
Agreed, especially since it doesn't seem to be used in many of the drivers.

Guenter
