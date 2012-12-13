Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2LMTTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:19:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36614 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754660Ab2LMTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:19:04 -0500
Date: Thu, 13 Dec 2012 14:19:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <nautilus-list@gnome.org>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
In-Reply-To: <CANc+2y6yRSHXvnftmvhqdMafn-v3b2_28prx0DHQ+MA=9rMq8A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212131408510.1415-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012, prasannatsmkumar wrote:

> On Thu, Dec 13, 2012 at 11:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 13 Dec 2012, prasannatsmkumar wrote:
> >
> >> On Wed, Dec 12, 2012 at 2:07 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> > STOP UNIT means spin down the disk or eject the disc.  Since your phone
> >> > doesn't have a disk drive or an optical disc, no wonder this step
> >> > failed.
> >>
> >> Yes of course it does not have a optical disc or disk drive. But I
> >> thought if there is no such thing nautilus should not try to spin
> >> down. Linux kernel has nothing to do with this problem though.
> >
> > Right.  Bear in mind that nautilus may not have any way of finding out
> > whether the device has removable media, other than requesting for the
> > media to be ejected.  But if it doesn't know then failure of the
> > request shouldn't be reported as an error.
> 
> Is kernel not exposing this information?

What I wrote earlier was wrong, sorry.

No, the kernel does not export it.  But user programs can get the
information directly from the device in exactly the same way that the
kernel does, by issuing an INQUIRY command.

>  The other OS shows "Eject"
> for the android device and for other pen drive I get a "safely remove"
> option - stated this assuming the options in nautilus and the other OS
> mean the same.

Alan Stern

