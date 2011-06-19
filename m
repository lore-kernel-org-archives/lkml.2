Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1FSSLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:11:34 -0400
Received: from lunge.queued.net ([66.23.231.200]:56206 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab1FSSLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:11:33 -0400
Date: Sun, 19 Jun 2011 11:11:27 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>, cjb@laptop.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com,
        libertas-dev@lists.infradead.org
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110619111127.005064d0@debxo>
In-Reply-To: <BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
References: <20110618213803.521db1b3@debxo>
	<20110618214203.0028ba85@debxo>
	<BANLkTimyFj+iTWAopPMEyohP2pop_=g=6g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 10:41:22 +0100
Daniel Drake <dsd@laptop.org> wrote:

> On 19 June 2011 05:42, Andres Salomon <dilinger@queued.net> wrote:
> >>  LICENCE.OLPC                 |   33
> >> +++++++++++++++++++++++++++++++++ WHENCE                       |
> >> 20 ++++++++++++++++++++ libertas/lbtf_sdio.bin       |  Bin 0 ->
> >> 120924 bytes libertas/lbtf_usb.bin        |  Bin 0 -> 118888 bytes
> >>  libertas/sd8686_v9_OLPC.bin  |  Bin 0 -> 124244 bytes
> >>  libertas/usb8388_v5_OLPC.bin |  Bin 0 -> 127824 bytes
> >
> > Of course, if people would prefer the OLPC version to supersede the
> > ones currently in the linux-firmware tree, I can do that instead.  I
> > don't know what versions of sd8686.bin and usb8388.bin are actually
> > in the tree.  I also don't know if the OLPC versions improve or
> > make things worse for people using those chips on non-OLPC systems.
> 
> This overlaps with a submission I made the other day (of usb8388
> firmware), sorry for the lack of coordination there.

Ah, sorry, I didn't know you were on top of this.  I'm wanting to
kill off the Debian OLPC-specific libertas package, and finally found
some time to put together a pull request.

> 
> I don't think the OLPC hardware has any quirks or special features
> that mean it requires special firmware.
> 
> However, for the usb8388 we do use a special firmware developed by
> Cozybit (not Marvell), the one you submitted, which has its own
> versioning scheme. The main difference is that it includes mesh
> support. I am pretty sure it would run on any usb8388 but OLPC is the
> only user of the hardware anyway. See
> http://lists.infradead.org/pipermail/libertas-dev/2010-November/003330.html
> and the rest of the discussion.
> 
> As for sd8686, I thought our firmware was standard, from Marvell, and
> simply a newer version of what is in linux-firmware. Do you have
> reason to believe otherwise?
> 

I was just playing it safe.  I have changelogs for the usb8388 firmware
releases, but not for sd8686.  I'll defer to you for XO-1.5 stuff.

I'm more interested in the lbtf stuff anyways, as I don't see much use
for the on-chip mesh.
