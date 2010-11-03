Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0KCTjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:39:42 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:37645 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab0KCTji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:39:38 -0400
Date: Wed, 3 Nov 2010 20:40:51 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: maciej.rutecki@gmail.com
Cc: =?UTF-8?B?VMO1bnU=?= Samuel <tonu@jes.ee>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: gspca for_2.6.36 - maybe does not work properly for me
Message-ID: <20101103204051.13407da4@tele>
In-Reply-To: <201011032007.25474.maciej.rutecki@gmail.com>
References: <1288264077.1891.40.camel@x41.itrotid.ee>
	<201011032007.25474.maciej.rutecki@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010 20:07:25 +0100
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> (add CC's)
> On czwartek, 28 października 2010 o 13:07:57 Tõnu Samuel wrote:
> > I am Sony PS3 Eye webcam user.
> > 
> > After installing 2.6.36 this camera gets recognized but actually
> > does not work. It might be some own stupidity of improper kernel
> > configuration but I cannot track it down at moment.
> > 
> > relevant dmesg:
> > 
> > [ 1372.224068] usb 1-5: new high speed USB device using ehci_hcd and
> > address 5
> > [ 1372.359574] usb 1-5: New USB device found, idVendor=1415,
> > idProduct=2000
> > [ 1372.359582] usb 1-5: New USB device strings: Mfr=1, Product=2,
> > SerialNumber=0
> > [ 1372.359588] usb 1-5: Product: USB Camera-B4.04.27.1
> > [ 1372.359593] usb 1-5: Manufacturer: OmniVision Technologies, Inc.
> > [ 1372.360623] gspca: probing 1415:2000
> > [ 1372.483830] ov534: Sensor ID: 7721
> > [ 1372.534205] ov534: frame_rate: 30
> > [ 1372.534319] gspca: video0 created
	[snip]
> 2.6.35,  or  another, older kernel works OK?

Hi,

Yes, this is a regression. It has been fixed last month, but too late
for 2.6.36 (commit f43402fa55bf5e7e190c176343015122f694857c).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
