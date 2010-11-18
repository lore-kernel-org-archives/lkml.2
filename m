Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab0KRQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:44:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1532 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab0KRQoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:44:12 -0500
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
In-Reply-To: <20101118103758.GB7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <1290040194.28741.324.camel@Joe-Laptop>
	 <1290040508.16344.532.camel@c-dwalke-linux.qualcomm.com>
	 <20101118103758.GB7233@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 08:44:11 -0800
Message-ID: <1290098651.1817.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 10:37 +0000, Mark Brown wrote:
> On Wed, Nov 17, 2010 at 04:35:08PM -0800, Daniel Walker wrote:
> >                         printk(KERN_WARNING "%s: could not add regulator_dev"
> >                                 " load sysfs\n", __func__);
> > I'm not sure what this one was suppose to say.
> That's a different thing - someone's just split the string over multiple
> lines - the two strings will just be concatenated.

I believe he's talking about the concatenated string
content itself being unintelligible gibberish.

It'd be more standard as "could not create sysfs file".


