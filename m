Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2CZNWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab2CZNWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:22:30 -0400
Date: Mon, 26 Mar 2012 09:22:27 -0400
From: Dave Jones <davej@redhat.com>
To: Guan Xin <guanx.bac@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Remove over-broad module alias from zaurus.
Message-ID: <20120326132227.GA22887@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Guan Xin <guanx.bac@gmail.com>, linux-kernel@vger.kernel.org
References: <CANeMGR5xS6GwG18q5QnKt5_pWJB4fEKFoywZDx=kA_JFVREGxw@mail.gmail.com>
 <20120326124929.GA4190@redhat.com>
 <CANeMGR7-_sDbkSXKJd0svEn0R983WNoaVnDdgBU6OzBt67Db+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeMGR7-_sDbkSXKJd0svEn0R983WNoaVnDdgBU6OzBt67Db+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:14:00PM +0200, Guan Xin wrote:
 > On Mon, Mar 26, 2012 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:

 > > Yes, just cut-n-paste one of the other entries, change the ID,
 > > make sure it works and send a diff.
 > >
 > This patch is tested to work with 2.6.39.4 and 3.2.13.
 > 
 > --- a/drivers/net/usb/zaurus.c  2012-03-26 14:59:36.702998639 +0200
 > +++ b/drivers/net/usb/zaurus.c  2012-03-26 15:02:16.860801959 +0200
 > @@ -332,6 +332,11 @@
 >         .driver_info = ZAURUS_PXA_INFO,
 >  },
 >  {
 > +       /* Motorola Rokr E6 */
 > +       USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6027, USB_CLASS_COMM,
 > +                       USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
 > +       .driver_info = (unsigned long) &bogus_mdlm_info,
 > +}, {
 >         /* Motorola MOTOMAGX phones */
 >         USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
 >                         USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
 > 

Looks good, but needs a Signed-off-by: line. See Documentation/SubmittingPatches
(Also Cc: netdev@vger.kernel.org so it gets picked up by patchwork)

thanks,

	Dave

