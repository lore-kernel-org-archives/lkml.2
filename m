Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1GGEPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:15:16 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:33969
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1GGEPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:15:11 -0400
Date: Wed, 6 Jul 2011 21:14:32 -0700
From: matt mooney <mfm@muteddisk.com>
To: Matt Chen <machen@novell.com>
Cc: N?meth M?rton <nm127@freemail.hu>, David Chang <DChang@novell.com>,
        Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
        Max Vozeler <max@vozeler.com>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, usbip-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] USBIP protocol documentation
Message-ID: <20110707041432.GA62825@haskell.muteddisk.com>
Mail-Followup-To: Matt Chen <machen@novell.com>,
	N?meth M?rton <nm127@freemail.hu>, David Chang <DChang@novell.com>,
	Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
	Max Vozeler <max@vozeler.com>, Joe Perches <joe@perches.com>,
	linux-usb@vger.kernel.org, usbip-devel@lists.sourceforge.net,
	devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
References: <20110524183448.GA18511@kroah.com> <4DDC142E.6070003@freemail.hu> <20110525031222.GB14290@haskell.muteddisk.com> <4DDC93D5.9070607@freemail.hu> <4DDDFDA7.6030900@freemail.hu> <4E097A32.1000504@freemail.hu> <BANLkTimG_kWr_YPVMasUr+7+KRFPnnbjNw@mail.gmail.com> <CAL-cBk1L8dgAtP2hMwkL2B-cU76mKaaWib=QVbVKei2DaoB3Dw@mail.gmail.com> <4E1151BD.5010907@freemail.hu> <CALx5=V-YdXY2UCS5UQUBZmQjMCUO7xZCOE-tf-s2MkD+2TXuxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALx5=V-YdXY2UCS5UQUBZmQjMCUO7xZCOE-tf-s2MkD+2TXuxQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:24 Mon 04 Jul     , Matt Chen wrote:
> Hi N?meth,
> 
> 2011/7/4 N?meth M?rton <nm127@freemail.hu>:
> > Hi David, Matt Chen and Matt Mooney,
> >
> > it looks like we four are actively dealing with the USBIP protocol documentation.
> >
> > David, are you working at the same place like Matt Chen? Then you can easily
> > see what you two has been done and not working parallel on the same thing.
> Actually, David and me (Matt Chen) are working on 2 different part.
> 1. Matt Chen : Server side
> 2. David Chang : Client side.
> Just didn't figure you submitted the protocol document earlier than we do.
> We also write a wiki for our code reviewing, protocol, but since all
> we are working personally, something we don't sync, that's why I tried
> to ask if which part you are not working on or finished, we can work
> on it.

Hey guys,

It seems like you guys all have a handle on this, so I will defer. When the
documentation is at a point where it can be submitted, I will send in grammar
patches along with possible reorganization suggestions.

Is this a public wiki Matt so that you can post a link to it?

Thanks,
mfm

> Since you submitted the document, it turned out we follow the format
> you've done and do some fix for it.
> > I'm currently not actively modifying the USBIP protocol description.
> >
> > Matt Mooney wanted to restructure the USBIP protocol documentation. Matt, do
> > you have anything already done? If yes, maybe it would be good if you could
> > send it so David can do the changes on your version. If you haven't worked on
> > it then please tell and David can add the necessary modifications he suggested.
> I supposed it is Matt Mooney. ~ :)
> > Regards,
> >
> > ? ? ? ?M?rton N?meth
> >
> > David Chang wrote:
> >> Hi N?meth,
> >>
> >> 2011/6/29 David Chang <dchang@novell.com>:
> >>> Hi,
> >>>
> >>> Thanks for your great effort.
> >>> Just a little comment on UNLINK pdu size.
> > [...]
> >> Would you add this field into your path or should I send another patch
> >> to add it?
> >
> >
> 
> 
> 
> --
> Thanks ~
> Matt Chen
> 
