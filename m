Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1GBMiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:38:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48545 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754167Ab1GBMiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:38:21 -0400
Date: Sat, 2 Jul 2011 08:38:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
In-Reply-To: <20110702060846.GH23059@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1107020837220.11097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jul 2011, Andi Kleen wrote:

> > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > give the exact sequence of steps you went through to trigger the bug?
> 
> Connect USB storage device with builtin fake CD rom. Wait for udisk
> to mount it. Pull cable. udisk does umount. Oops.
> 
> I also got a log of the refcounting now if you want it.

Yes, please.  The excerpt that James posted isn't enough.  In 
particular, it doesn't show what happens during device creation.

Alan Stern

