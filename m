Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1GBSKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 14:10:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1GBSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:10:14 -0400
Date: Sat, 2 Jul 2011 20:10:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl,
        linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110702181008.GL23059@one.firstfloor.org>
References: <20110702060846.GH23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107020837220.11097-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107020837220.11097-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 08:38:20AM -0400, Alan Stern wrote:
> On Sat, 2 Jul 2011, Andi Kleen wrote:
> 
> > > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > > give the exact sequence of steps you went through to trigger the bug?
> > 
> > Connect USB storage device with builtin fake CD rom. Wait for udisk
> > to mount it. Pull cable. udisk does umount. Oops.
> > 
> > I also got a log of the refcounting now if you want it.
> 
> Yes, please.  The excerpt that James posted isn't enough.  In 
> particular, it doesn't show what happens during device creation.

http://halobates.de/tmp/usb-pull-oops-ref

-Andi
