Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1JCLiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:38:14 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19091 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab1JCLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:38:08 -0400
From: <oskar.andero@sonyericsson.com>
Date: Mon, 3 Oct 2011 13:38:21 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Kvist=2C_H=E5kan?= <Hakan.Kvist@sonyericsson.com>
Subject: Re: [PATCH] USB: ftdi_sio: add PID for Sony Ericsson Urban
Message-ID: <20111003113820.GA2747@caracas.corpusers.net>
References: <1317631891-13648-1-git-send-email-oskar.andero@sonyericsson.com>
 <4E898F99.8080507@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E898F99.8080507@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12:34 Mon 03 Oct     , Sergei Shtylyov wrote:
> Hello.
> 
> On 03-10-2011 12:51, oskar.andero@sonyericsson.com wrote:
> 
> > From: Hakan Kvist <hakan.kvist@sonyericsson.com>
> 
> > Add PID 0xfc8a, 0xfc8b for device Sony Ericsson Urban
> 
> > Signed-off-by: Hakan Kvist <hakan.kvist@sonyericsson.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> [...]
> 
> > diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> > index bf5227a..9617f91 100644
> > --- a/drivers/usb/serial/ftdi_sio_ids.h
> > +++ b/drivers/usb/serial/ftdi_sio_ids.h
> > @@ -420,9 +420,11 @@
> >   #define PROTEGO_SPECIAL_4	0xFC73	/* special/unknown device */
> >
> >   /*
> > - * DSS-20 Sync Station for Sony Ericsson P800
> > + * Sony Ericsson product ids
> >    */
> > -#define FTDI_DSS20_PID          0xFC82
> > +#define FTDI_DSS20_PID          0xFC82 /* DSS-20 Sync Station for Sony Ericsson P800 */
> > +#define FTDI_URBAN_0_PID        0xFC8A /* Sony Ericsson Urban, uart #0 */
> > +#define FTDI_URBAN_1_PID        0xFC8B /* Sony Ericsson Urban, uart #1 */
> 
>     Please indent the values with tabs, not spaces.

Yes, of course! New patch coming up.

-Oskar
