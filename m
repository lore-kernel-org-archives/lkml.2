Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0JGVPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:15:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33061 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab0JGVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:15:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56990689"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 14:14:54 -0700
Message-ID: <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 17:03 -0400, Mike Frysinger wrote:
> On Thu, Oct 7, 2010 at 16:51, Daniel Walker wrote:
> > On Thu, 2010-10-07 at 22:05 +0100, Alan Cox wrote:
> >> On Thu, 07 Oct 2010 13:36:06 -0700 Daniel Walker wrote:
> >> > On Thu, 2010-10-07 at 21:50 +0100, Alan Cox wrote:
> >> > > > +         Say Y here if you want to install DCC driver as a normal serial port
> >> > > > +         /dev/ttyS0 (major 4, minor 64). Otherwise, it appears as /dev/ttyJ0
> >> > > > +         (major 4, minor 128) and can co-exist with other UARTs, such as
> >> > > > +         8250/16C550 compatibles.
> >> > > > +
> >> > >
> >> > > NAK to both
> >> >
> >> > I would agree if this wasn't strictly for debugging embedded devices in
> >> > difficult situations.. After talking to Mike, it's seems like it would
> >> > be useful to have this as a ttyS* specifically because embedded devices
> >> > won't always create a ttyJ* for you and ttyS* will likely already exist.
> >>
> >> If you are debugging an embedded device you are capable of changing it
> >> (otherwise you wouldn't debug it). Therefore the fact you might need to
> >> tweak the tty creation on the device is not a problem. If you can't
> >> change the device well there is no point debugging it is there !
> >
> > Your making too many assumptions .. You might be able to modify the
> > kernel, and not the userspace. So you couldn't tweak the device
> > creation .. It's much easier in the server world ..
> 
> this driver isnt in the kernel.  there is no ABI to preserve.  if
> people want to use the mainline driver, they can fix their userspace.
> i dont think the "binary userspace" argument is terribly relevant to
> new driver submissions.

It is , what's to stop any userspace from using ttyS0 ? .. There's lots
of binary userspaces in the embedded world, along with many strange
usages ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

