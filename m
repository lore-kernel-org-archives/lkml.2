Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2B0CTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:19:48 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:32382
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752568Ab2B0CTq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:19:46 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz9371I542M1432N98dK4015Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h946hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Shengzhou-B36685 <B36685@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some
 platform
Thread-Topic: [PATCH] powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some
 platform
Thread-Index: AQHM89bZMQRU9YlG0023kOKy4wD+KZZOOJOAgAHICGA=
Date: Mon, 27 Feb 2012 02:19:36 +0000
Message-ID: <3F453DDFF675A64A89321A1F3528102170B502@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1330185390-30614-1-git-send-email-Shengzhou.Liu@freescale.com>
 <20120225165219.GA21703@kroah.com>
In-Reply-To: <20120225165219.GA21703@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.89]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, February 26, 2012 12:52 AM
> To: Liu Shengzhou-B36685
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on
> some platform
> 
> On Sat, Feb 25, 2012 at 11:56:30PM +0800, Shengzhou Liu wrote:
> > Fix checking of CTRL_PHY_CLK_VALID bit break on some platform on
> which
> > there is not USB CTRL_PHY_CLK_VALID bit.
> >   - P1023/P3041/P5020 etc,have this bit
> >   - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
> >   - P1022(perhaps and other) has no this bit
> >
> > Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> > ---
> >  drivers/usb/host/ehci-fsl.c |   24 ++++++++++++++----------
> >  1 files changed, 14 insertions(+), 10 deletions(-)
> 
> Is this something that needs to go into 3.3, or can it wait for 3.4?
> 
> thanks,
> 
> greg k-h

I'm waiting for the response from FSL silicon team to confirm 
whether there is other platform not including this bit or not,
So if not emergent to fix it on P1022, we can wait for 3.4, or go into 3.3 first.

Thanks,
Shengzhou

