Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab0JTEHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:07:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3133 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0JTEHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:07:44 -0400
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
In-Reply-To: <20101020035346.GA20178@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020032938.GA20095@ericsson.com>
	 <1287545658.10409.606.camel@Joe-Laptop>
	 <20101020035346.GA20178@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 21:07:42 -0700
Message-ID: <1287547662.10409.618.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 20:53 -0700, Guenter Roeck wrote:
> On Tue, Oct 19, 2010 at 11:34:18PM -0400, Joe Perches wrote:
> > On Tue, 2010-10-19 at 20:29 -0700, Guenter Roeck wrote:
> > > There are several lines longer than 80 characters.
> > > Does this rule no longer apply ?
> > 80 columns isn't checked for printk format strings.
> Interesting.
> > A kernel general preference may be to keep formats as
> > a single string without line breaks so that grep works
> > better.
> > > Oddly enough, there are only four checkpatch warnings about long lines,
> > > even though there are many more.
> > The version I use doesn't show any warnings.
> checkpatch.pl from both v2.6.36-rc7 and v2.6.36-rc6 do report warnings.
> Looks like those versions flag long lines for pr_warn. Is your version
> older or newer ?

Newer.  It adds pr_warn to the exempted list, not just pr_warning.

> Anyway, would it be possible to split the patch into one patch per file ?

Oh sure.  It's trivial to do that.

> I don't know how Jean thinks about it, but in my opinion it would be cleaner,
> permit revert on a single patch/file instead of having to revert the entire series,
> it would simplify review, and it would make it much easier to cherry-pick 
> pieces into other releases if needed.

Jean, do you have a preference?
I'll resubmit if you want it separated.

