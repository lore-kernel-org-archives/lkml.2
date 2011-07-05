Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1GEN5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:57:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48734 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751074Ab1GEN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:57:49 -0400
Date: Tue, 5 Jul 2011 09:57:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <201107050910.57432.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107050956260.2060-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Arkadiusz Miskiewicz wrote:

> > Ah, very good!  That explains everything.  Someone else reported a
> > similar problem that was tracked down to this commit, and I submitted a
> > fix a few days ago:
> > 
> > 	http://marc.info/?l=linux-usb&m=130955300211987&w=2
> > 
> > I bet this will fix your problem too.
> 
> Unfortunately it doesn't fix my problem (rc6 + that patch).
> 
> usb still hangs after resume and repluging device causes no effect.

When this hang occurs, can you get a stack dump?  Alt-SysRq-W or
something similar.  I'm particularly curious to see what the khubd
thread is doing.

Alan Stern

