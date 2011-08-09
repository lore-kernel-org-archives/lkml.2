Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1HIOXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:23:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50555 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722Ab1HIOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:23:05 -0400
X-Sasl-enc: V6Zi+M6/YoFMP8TptaDWtjsKBQ6Zj3rm0S9guGg8q8xU 1312899784
Date: Tue, 9 Aug 2011 07:22:56 -0700
From: Greg KH <greg@kroah.com>
To: David Chang <dchang@suse.com>
Cc: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        Matthew Wilcox <matthew@wil.cx>, Max Vozeler <max@vozeler.com>,
        Matt Mooney <mfm@muteddisk.com>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, usbip-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] USBIP protocol documentation
Message-ID: <20110809142256.GB1805@kroah.com>
References: <4DDBF8BD.3000603@freemail.hu>
 <20110524183448.GA18511@kroah.com>
 <4DDC142E.6070003@freemail.hu>
 <20110525031222.GB14290@haskell.muteddisk.com>
 <4DDC93D5.9070607@freemail.hu>
 <4DDDFDA7.6030900@freemail.hu>
 <4E097A32.1000504@freemail.hu>
 <CAL-cBk1Kzr1Gn3YCHDpudkVSmdSWOcCo7_rpLddCUQ_3ZjP+kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL-cBk1Kzr1Gn3YCHDpudkVSmdSWOcCo7_rpLddCUQ_3ZjP+kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:23:14PM +0800, David Chang wrote:
> Hi Greg,
> 
> 2011/6/28 Németh Márton <nm127@freemail.hu>:
> > From: Márton Németh <nm127@freemail.hu>
> >
> > USBIP v1.0.0 protocol documentation.
> >
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > ---
> >
> > Hi,
> >
> > I tried to document the USBIP protocol as implemented in the Linux kernel 3.0-rc2.
> >
> > The description is a preliminary draft only, it may contain mistakes. I tried
> > to document what I have understand from the source code and from the actual
> > captured network traffic when the USBIP is in action. Please review it, correct it,
> > point out the missing parts.
> >
> > During I have documented the protocol a question came into my mind: why do we
> > have two different type of package when the URB completition handler is called,
> > namely USB_RET_SUBMIT and USBIP_RET_UNLINK? As far as I can see this causes race
> > condition because for one URB the completition handler is only called once. If
> > the one URB is sent in with USB_CMD_SUBMIT and then unlinked with USB_CMD_UNLINK
> > the completition handler is called only once. In the protocol, however, we have
> > two different type of packets: USB_RET_SUBMIT and USBIP_RET_UNLINK. The status
> > field of these messages may contain anything in this case depending on the timing.
> >
> > Regards,
> >
> >        Márton Németh
> 
> Sorry, just one question about the usbip protocol document.
> I would like to know why didn't you apply this patch.

Because it was sent as a "RFC" (i.e. request for comments) and based on
the discussion afterward, there were lots of comments :)

If someone wants to resend it to me, without that marking, I'll be glad
to apply it.

thanks,

greg k-h
