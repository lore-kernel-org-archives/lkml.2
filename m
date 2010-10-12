Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0JLWkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:40:17 -0400
Received: from clarity.mcc.ac.uk ([130.88.200.144]:56458 "EHLO
	clarity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0JLWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:40:16 -0400
X-Greylist: delayed 1065 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 18:40:16 EDT
Subject: Re: Lenovo S12 2.6.36-rc7 lockup
From: sam <sam.tygier@hep.manchester.ac.uk>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20101010164818.6617102c@boulder.homenet>
References: <20101010135912.76eb61b7@boulder.homenet>
	 <20101010164818.6617102c@boulder.homenet>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 23:22:26 +0100
Message-ID: <1286922146.4040.2.camel@oberon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: Samuel Tygier from ([192.168.1.149]) [87.127.117.246]:40706
X-Authenticated-From: samuel.tygier@postgrad.manchester.ac.uk
X-Spam-Score: -5.0(?)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-10 at 16:48 +0100, Chris Vine wrote:
> On Sun, 10 Oct 2010 13:59:12 +0100
> Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> > Hi,
> > 
> > kernel 2.6.36-rc7 completely locks up my Lenovo S12 notebook on
> > boot-up. It happens early enough in boot-up that nothing appears in
> > any of the system log files.  The last message printed to the console
> > is "Using IPI - No Shortcut mode".
> > 
> > The lock up does not occur with kernel 2.6.35.6.  I do not know in
> > what version of 2.6.36-rc this first arose.
> > 
> > The kernel configuration is set out below.
> > 
> > Chris
> [snip]
> 
> On testing now with the earlier 2.6.36-rc6, I see that it is not a
> lock-up but a hang, in that it partly responds to the keyboard.  With
> rc6 boot-up can proceed further than with rc7 (but very slowly) if
> keyboard keys are more or less randomly pressed.  Boot up is never
> completed though with rc6, even though it proceeds further.
> 
> Chris

i have seen similar issue while running with older kernels (2.6.32) on a
S12 (intel GPU version). there is an ubuntu bug
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/643822

the "nolapic_timer" boot flag fixes it for me.

sam

