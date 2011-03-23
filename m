Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab1CWPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:10:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54968 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932337Ab1CWPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:10:11 -0400
Date: Wed, 23 Mar 2011 15:10:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323151008.GD25754@opensource.wolfsonmicro.com>
References: <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <1300828125.2402.300.camel@pasglop>
 <4D8924B6.8040403@linaro.org>
 <1300842219.2402.309.camel@pasglop>
 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
 <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
 <20110323093847.55e9dbba@lxorguk.ukuu.org.uk>
 <20110323105335.GB778@opensource.wolfsonmicro.com>
 <20110323150413.GC6284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323150413.GC6284@kroah.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:04:13AM -0700, Greg KH wrote:

> I asked for concrete examples of a need for this type of thing (i.e.
> platform data on USB devices), and this was the only need cited.  I

No, it isn't.  I previously mentioned the example of a system where the
ethernet controller was wired to several PHYs none of which were
connected to the data lines.  The driver needed to be told to use
special PHY detection logic to work on this system.  In general anything
which may be configured via the SEPROM may need overriding from software
on a system without the SEPROM - consulting the datasheet for a USB
ethernet controller should give an idea of the things that might need to
be configured.
