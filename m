Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0JTQ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:27:52 -0400
Received: from mail.perches.com ([173.55.12.10]:3332 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab0JTQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:27:51 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
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
In-Reply-To: <20101020093438.07b129c8@endymion.delvare>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020032938.GA20095@ericsson.com>
	 <1287545658.10409.606.camel@Joe-Laptop>
	 <20101020035346.GA20178@ericsson.com>
	 <1287547662.10409.618.camel@Joe-Laptop>
	 <20101020093438.07b129c8@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 09:27:48 -0700
Message-ID: <1287592068.1813.185.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:34 +0200, Jean Delvare wrote:
> Joe, would you mind providing a similar patch for the driver at:
>   http://khali.linux-fr.org/devel/misc/w83795/w83795.c
> This driver will be added to kernel 2.6.37.

This file doesn't use printk and doesn't need any similar patch.




