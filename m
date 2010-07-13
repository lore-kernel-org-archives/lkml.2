Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0GMUmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:42:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58721 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0GMUml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:42:41 -0400
Date: Tue, 13 Jul 2010 22:42:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Branislav Gajdos <brianzee@gmail.com>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
Message-ID: <20100713204235.GA32085@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Branislav Gajdos <brianzee@gmail.com>,
	Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
 <20100713124840.GA16427@a1.tnic>
 <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
 <20100713151329.GA17516@a1.tnic>
 <cone.1279041124.439539.3902.1000@deskpiie>
 <AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Branislav Gajdos <brianzee@gmail.com>
Date: Tue, Jul 13, 2010 at 10:30:14PM +0200

> Hi Peter,
> 
> On Tue, Jul 13, 2010 at 7:12 PM, Peter Feuerer <peter@piie.net> wrote:
> >>
> >>> >> acerhdf: unknown (unsupported) BIOS version Acer/Aspire 3810T/V1.04,
> >>> >> please report, aborting!
> >
> > Which distribution do you use? Does the distribution somehow autoload
> > acerhdf? Or do you manually load the driver?
> 
> I compiled the kernel myself and chose the driver as my notebook was
> Acer Aspire, I didn't realize it was meant only for netbooks :-)
> 
> > I would propose to enhance the bios_tbl by the default temperatures. What do you think?
> 
> So that means you would keep there the definitions for Core 2 based
> models as well, right?

You still didn't answer my question whether your fan is noisy? IOW, does
it make sense for you to use this driver at all?

-- 
Regards/Gruss,
    Boris.
