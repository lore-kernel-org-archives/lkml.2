Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1LKTfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 14:35:20 -0500
Received: from billgribble.com ([65.99.215.30]:51614 "EHLO
	mail.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1LKTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 14:35:17 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Dec 2011 14:35:17 EST
Date: Sun, 11 Dec 2011 14:24:51 -0500
From: Bill Gribble <grib@billgribble.com>
To: linux-kernel@vger.kernel.org
Subject: Mystery clicking under keyboard, 3.x only, SSD only
Message-ID: <20111211142451.63febb26@pequin>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running Debian Sid on a Viliv N5, which is an Atom Z520/Poulsbo
(GMA500) UMPC.  It has no rotating media or fans. With Debian's
linux-image-2.6.39-2-686-pae and earlier kernels behavior is normal
(except for flaky libertas wifi, which is why I seek to upgrade). 

Any 3.0 or 3.1 kernel I have tried from Debian (I have tried each
incremental version, most recently linux-image-3.1.0-1-686-pae) starts,
within a minute after boot, to make a soft clicking noise from under
the keyboard.  Clicks appear to be correlated with
interrupt-generating activity such as moving a mouse pointer or
pressing keys.  This clicking does not start in earnest until an X
server comes up, but even booting into single-user mode I hear it
some.  With an X display up, there is a continuous stream of 5-10
clicks per second, more when moving the mouse pointer.

There is no disk or fan on this machine (SSD only).  The audio system
is Intel HDA; I have tried muting all mixer channels, turning all
volumes to 0, even blacklisting all the intel HDA modules and all the
pc speaker modules.  In any case, the speaker for the device is in the
screen bezel, not the keyboard (I think; I have never gotten the
speaker to work properly).  

I have also tried blacklisting the psb_gfx module in 3.1.  

I see nothing of interest in any logs.  Nothing I have done changes the
behavior at all.

Any thoughts about what this could be?  I am getting a little crazy
about it.  

Thanks,
Bill Gribble

 

