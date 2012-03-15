Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2COGyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:54:06 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:54340 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2COGyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:54:01 -0400
Message-ID: <20321.37353.63115.664975@ipc1.ka-ro>
Date: Thu, 15 Mar 2012 07:53:29 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: "s.hauer\@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "vinod.koul\@linux.intel.com" <vinod.koul@linux.intel.com>,
        "devicetree-discuss\@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring\@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rdunlap\@xenotime.net" <rdunlap@xenotime.net>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        "cjb\@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
In-Reply-To: <20120315030206.GB13022@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
	<1331628428-24017-2-git-send-email-b29396@freescale.com>
	<20120313172351.97C5E3E053B@localhost>
	<20120314124512.GG1180@shlinux2.ap.freescale.net>
	<20120314141643.GP3852@pengutronix.de>
	<20120315030206.GB13022@shlinux2.ap.freescale.net>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dong Aisheng writes:
> On Wed, Mar 14, 2012 at 10:16:43PM +0800, s.hauer@pengutronix.de wrote:
> > On Wed, Mar 14, 2012 at 08:45:23PM +0800, Dong Aisheng wrote:
> > > On Wed, Mar 14, 2012 at 01:23:51AM +0800, Grant Likely wrote:
[...]
> > > But it seems this needs pass mac address to fec driver via platforom data which is
> > > not friendly to dt.
> > > 
> > > Another way may be changing fec driver to get the fixed part of mac address(first
> > > two bytes) from device tree and read the left dynamical part from otp which i'm not
> > > sure is better enough.
> > > 
> > > BTW, filling with zeros seems not work since it's invalid mac address.
> > 
> > Yes, that's the idea of using this value...
> > 
> But comparing to use an invalid value, why not just do not define that
> local-mac-address property?
> 
Because a MAC address is by definition a GLOBALLY UNIQUE IDENTIFIER
which is contrary to coding a "valid" default value for it somewhere!
The owner of a certain MAC address range (OUI) is responsible for
ensuring the uniqueness. Thus only they may assign a specific MAC
address to a specific device.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
