Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0JTDeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:34:25 -0400
Received: from mail.perches.com ([173.55.12.10]:3119 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab0JTDeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:34:24 -0400
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
In-Reply-To: <20101020032938.GA20095@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020032938.GA20095@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 20:34:18 -0700
Message-ID: <1287545658.10409.606.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 20:29 -0700, Guenter Roeck wrote:
> On Tue, Oct 19, 2010 at 07:13:40PM -0400, Joe Perches wrote:
> > Convert printks to pr_<level>
> > Coalesce long formats
> > Removed prefixes from formats
> > Added #define pr_fmt KBUILD_MODNAME ": " fmt
> > Standardized abitguru messages for reporting and finding MAINTAINER
> > Compiled x86 allyesconfig only.
> > I inspected "strings drivers/hwmon/built-in.o",
> > but it's otherwise untested.
> > Signed-off-by: Joe Perches <joe@perches.com>
> There are several lines longer than 80 characters.
> Does this rule no longer apply ?

80 columns isn't checked for printk format strings.

A kernel general preference may be to keep formats as
a single string without line breaks so that grep works
better.

> Oddly enough, there are only four checkpatch warnings about long lines,
> even though there are many more.

The version I use doesn't show any warnings.

cheers, Joe

