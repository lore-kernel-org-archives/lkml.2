Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0GMPNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:13:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59860 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0GMPNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:13:33 -0400
Date: Tue, 13 Jul 2010 17:13:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Branislav Gajdos <brianzee@gmail.com>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
Message-ID: <20100713151329.GA17516@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Branislav Gajdos <brianzee@gmail.com>,
	Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
 <20100713124840.GA16427@a1.tnic>
 <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Branislav Gajdos <brianzee@gmail.com>
Date: Tue, Jul 13, 2010 at 04:27:37PM +0200

> >> acerhdf: unknown (unsupported) BIOS version Acer/Aspire 3810T/V1.04,
> >> please report, aborting!
> >
> > It doesn't look to me like this machine is a netbook with an Atom cpu
> > supported by this driver. Do as root:
> 
> That's possible, I'm not sure what exactly this driver does. However,
> I've seen Aspire 1810T definitions in the file already (in bios_tbl
> table) which is afaik 11" version of 3810T, so I decided to report it
> for completeness.

Hmm, acerhdf is a driver for, originally, acer aspire one netbooks with
noisy fans. We have static limits which turn on the fan at 63 °C and
off again when the temperature reaches 58 °C - those are at least the
defaults.

Now you have a Core 2 Duo U9400 for which I can't find the specs after a
quick search but it looks like something a little bit more powerful than
a netbook cpu but still ultra low power. So, before we dig further into
this, is your fan noisy at all?

Peter, it looks like we support not only Atoms with that driver. Maybe
we should check the cpu specs of the 1810T for example (and google says
there are several different cpu types packaged with those laptops)
before we enforce temperature limits on them...? And let me ask you
this: are all those 1810T* entries in the bios_tbl there because of
noisy fans ...?

Thanks.

-- 
Regards/Gruss,
Boris.
