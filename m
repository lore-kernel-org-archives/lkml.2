Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1FCRm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:42:26 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:41607 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1FCRmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110603171837.GA9918@opensource.wolfsonmicro.com>
References: <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com> <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk> <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com> <20110527201201.GA6645@ponder.secretlab.ca>
 <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com> <20110603171837.GA9918@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Jun 2011 11:42:04 -0600
X-Google-Sender-Auth: 4kGGIWKVtvUhwIp-7pwlqsF6FnE
Message-ID: <BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 11:18 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 03, 2011 at 11:04:52AM -0600, Grant Likely wrote:
>
>> I ended up not pushing this one to Linus.  Turns out it causes other
>> breakage on other platforms that don't include include/linux/gpio.h.
>> Since I don't have confidence that I'll be able to find all the
>> offenders, I'm dropping it.  I recommend making any drivers that are
>
> So, this originally came about because I pushed back on adding random
> dependencies like this for features which are pretty much optional in
> drivers - their use of GPIOs is totally optional and the dependencies
> are just too fragile, leading to noise with all the randconfigs.  It
> seems better to get the architectures to keep up with enhancements to
> gpiolib (or convert to it) than to have to worry about this in drivers.

Fair enough.  Randy, if you or someone else can check that all GPIOF_
users have the required #include <linux/gpio.h>, then I'm okay with
this patch.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
