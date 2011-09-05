Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1IEBRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 21:17:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34170 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753563Ab1IEBRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 21:17:03 -0400
Date: Sun, 4 Sep 2011 21:17:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lin Ming <mlin@ss.pku.edu.cn>
cc: Dave Young <hidave.darkstar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <fengguang.wu@intel.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [BUG] D state process after unplug and umount usb disk
In-Reply-To: <CAF1ivSaFt9ZBsM4s7NyjJWz6QBE7xcS21bXGADp4NPp=2XcYEA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109042112210.17099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Sep 2011, Lin Ming wrote:

> On Sun, Sep 4, 2011 at 9:49 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> >> Where does this exit signal come from?
> >> Does USB interrupt handler will send kill signal to all processes
> >> accessing it when it's unplugged(by hand)?
> >
> > The USB stack does not send any signals at all unless a process
> > specifically asks for them.
> 
> How to ask?

With the USBDEVFS_DISCSIGNAL ioctl.

> I have not checked, but think umount code path will not send signal to process.

I don't think so either.

Alan Stern

