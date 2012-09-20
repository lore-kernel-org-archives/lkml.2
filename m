Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2ITXfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:35:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46164 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab2ITXfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:35:23 -0400
Date: Thu, 20 Sep 2012 16:32:46 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] power_supply: add new lp8788 charger driver
Message-ID: <20120920233245.GC8209@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF2227@DQHE02.ent.ti.com>
 <20120920221638.GF18223@lizard>
 <A874F61F95741C4A9BA573A70FE3998F41EF5B1C@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF5B1C@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:19:07PM +0000, Kim, Milo wrote:
[...]
> > Had to fix a bunch of checkpatch complaints:
> > 
> > CHECK: space prohibited before semicolon
> > #478: FILE: drivers/power/lp8788-charger.c:396:
> > +       for (i = 0 ; i < pdata->num_chg_params ; i++) {
> > 
> > CHECK: space prohibited before semicolon
> > #541: FILE: drivers/power/lp8788-charger.c:459:
> > +       for (i = 0 ; i < pchg->num_irqs ; i++) {
> 
> Thanks a lot for this review.
> 
> It seems like the result of running checkpatch script with --strict option.
> Should I keep this option whenever submitting the file?
> I used to run w/o strict option.

It's up to you. But be aware that checkpach sometimes reports
false-positives, and --strict options makes signal/noise ratio even
worse.

So, checkpatch warnings (and especially with --strict options) are
just hints, sometimes very bogus. CodingStyle rules have a higer
priorty than automated stuff like checkpatch. :-)

> > But other than this, it looks really good, this is now applied.
> > 
> > Obviously, I couldn't compile-test it, but hopefully it will work
> > once MFD part is also in. :-) If not, you can just send a follow-up
> > fix.
> 
> Additionally, lp8788-charger depends on lp8788-adc driver.
> I've found wrong calculation on getting the battery voltage and temperature.
> I would submit this patch later.

Sure thing.

Thanks,
Anton.
