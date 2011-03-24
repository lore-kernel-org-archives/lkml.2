Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1CXNOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:14:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab1CXNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:14:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Thu, 24 Mar 2011 14:13:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Steve Calfee <stevecalfee@gmail.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
References: <4D79F068.2080009@linaro.org> <4D8A8471.9060904@gmail.com> <1300924878.2638.38.camel@bwh-desktop>
In-Reply-To: <1300924878.2638.38.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201103241413.54599.arnd@arndb.de>
X-Provags-ID: V02:K0:ccbE1Sf3mJdL1nbnVzsHuiPIQuL0L0Bc+RtD4Nis6U8
 LIKyITSJXVv1oJYFndM2Uhu1lInooHC9h2mnFIX7vpf02zsOMV
 +V6b8yGoAmfuJToI7wpIYNfOGpWTV0/XPpNsqakcpcoN5hH9he
 psanp7yAtuVNaffoT0VqF/uHjb912AeXG6M4k7t3nYqJBM7BNF
 Ux1mAQqmEzcgnPrULweWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 March 2011, Ben Hutchings wrote:
> On Wed, 2011-03-23 at 16:38 -0700, Steve Calfee wrote:
> > On 03/23/11 16:17, Michal Nazarewicz wrote:
> > >>> On Wednesday 23 March 2011 20:53:13 Michał Nazarewicz wrote:
> > >>>> I think P2P could be better.
> > >>
> > >> OTOH, I knew that PTP was point-to-point.
> > >
> > > It can be any of that, depending on context.  For me PTP is more like
> > > Picture Transport Protocol, whereas "2" between two letters is usually
> > > "to".
> > >
> > Well, my 2 cents, picture transport protocol is so obviously different 
> > than flags for network interfaces it does not cause a mental collision. 
> 
> PTP is also Precision Time Protocol, which *is* used on network
> interfaces (maybe not USB-connected interfaces though).
> 
> How about FLAG_NON_IEEE, meaning that the physical layer is not based on
> an IEEE 802.3, 802.11 or other standard physical layer.

I think that doesn't really express the meaning, since FLAG_WWAN is
presumably also not IEEE, right?

Thanks for the bike shedding everyone, I'll just use my own color then
and call it FLAG_POINTTOPOINT.

	Arnd
