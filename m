Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2HBMfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:35:34 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:41652 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab2HBMfd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:35:33 -0400
From: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>
Date: Thu, 2 Aug 2012 14:35:20 +0200
Subject: RE: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Topic: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Index: Ac1wngFrABAwD6vQRXCjNx/a8EhQlgABgaMgAAFEVtA=
Message-ID: <A3217089E06965468FCEC60ADC3A8F925C21599AE8@EXDCVYMBSTM006.EQ1STM.local>
References: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <20120802110010.GA5443@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Virupax SADASHIVPETIMATH
> Sent: Thursday, August 02, 2012 5:35 PM
> To: 'Greg KH'
> Cc: balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Praveena
> NADAHALLY
> Subject: RE: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, August 02, 2012 4:30 PM
> > To: Virupax SADASHIVPETIMATH
> > Cc: balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Praveena
> > NADAHALLY
> > Subject: Re: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
> >
> > On Thu, Aug 02, 2012 at 12:06:42PM +0530, Virupax Sadashivpetimath wrote:
> > > In case of USB bulk transfer, when himem page
> > > is received, the usb_sg_init function sets the
> > > urb transfer buffer to NULL. When such URB
> > > transfer is handled, kernel crashes in PIO mode.
> > > Handle this by mapping the highmem buffer in PIO mode.
> > >
> > > Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
> >
> > Why is this not a problem in any other host controller?
> 
> Problem is seen only when the RAM on the board is 1GB or more. When the urb sg is in
> highmem.

And also many of the host controllers are using the DMA mode for all sizes
 of urb transfer, because of which the problem is not seen in those controllers. 

Thanks 
Virupax S 
 




