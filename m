Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1FUHSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:18:25 -0400
Received: from lunge.queued.net ([66.23.231.200]:47533 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab1FUHSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:18:24 -0400
Date: Tue, 21 Jun 2011 00:18:05 -0700
From: Andres Salomon <dilinger@queued.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Daniel Drake <dsd@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        cjb@laptop.org, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110621001805.1caecc82@queued.net>
In-Reply-To: <1308631634.31157.7.camel@dcbw.foobar.com>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
	<BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
	<1308631634.31157.7.camel@dcbw.foobar.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 23:47:13 -0500
Dan Williams <dcbw@redhat.com> wrote:

> On Sun, 2011-06-19 at 10:41 +0100, Daniel Drake wrote:
> > On 19 June 2011 05:42, Andres Salomon <dilinger@queued.net> wrote:
> > >>  LICENCE.OLPC                 |   33
> > >> +++++++++++++++++++++++++++++++++ WHENCE
> > >> |   20 ++++++++++++++++++++ libertas/lbtf_sdio.bin       |  Bin
> > >> 0 -> 120924 bytes libertas/lbtf_usb.bin        |  Bin 0 ->
> > >> 118888 bytes libertas/sd8686_v9_OLPC.bin  |  Bin 0 -> 124244
> > >> bytes libertas/usb8388_v5_OLPC.bin |  Bin 0 -> 127824 bytes
> > >
> > > Of course, if people would prefer the OLPC version to supersede
> > > the ones currently in the linux-firmware tree, I can do that
> > > instead.  I don't know what versions of sd8686.bin and
> > > usb8388.bin are actually in the tree.  I also don't know if the
> > > OLPC versions improve or make things worse for people using those
> > > chips on non-OLPC systems.
> > 
> > This overlaps with a submission I made the other day (of usb8388
> > firmware), sorry for the lack of coordination there.
> > 
> > I don't think the OLPC hardware has any quirks or special features
> > that mean it requires special firmware.
> > 
> > However, for the usb8388 we do use a special firmware developed by
> > Cozybit (not Marvell), the one you submitted, which has its own
> > versioning scheme. The main difference is that it includes mesh
> > support. I am pretty sure it would run on any usb8388 but OLPC is
> > the only user of the hardware anyway. See
> > http://lists.infradead.org/pipermail/libertas-dev/2010-November/003330.html
> > and the rest of the discussion.
> > 
> > As for sd8686, I thought our firmware was standard, from Marvell,
> > and simply a newer version of what is in linux-firmware. Do you have
> > reason to believe otherwise?
> 
> For usb8388 I don't think we really care which firmware is default
> since OLPC was about the only consumer of that chip that I've ever
> heard of.
> 
> For the other firmware I periodically trawled Marvell's Extranet and
> grabbed latest firmware from there.  If you guys have a newer micro
> version of the firmware then great, push it.  Latest I have access to
> for 8686 is SD-8686-FEDORA26FC6-SYSKT-9.70.20.p0-26409.p64 so if
> you've got something newer great.


Looks like the one on dev.l.o is older (9.70.7.p0).  Shall I redo the
pull request a) ignoring sd8686, b) replacing usb8388 v5 with the OLPC
version, and c) including both thinfirm blobs as well, then?
