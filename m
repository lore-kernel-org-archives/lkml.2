Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1FHUpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:45:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39064 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754127Ab1FHUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:45:38 -0400
X-Authenticated: #1226656
X-Provags-ID: V01U2FsdGVkX19jI2JdD2JjA53SQmBALmIYVCRjo65lzZzHSOxjlN
	0cMyPRG8uqkFXm
Date: Wed, 8 Jun 2011 22:45:27 +0200
From: Marc Giger <gigerstyle@gmx.ch>
To: linux-kernel@vger.kernel.org
Subject: Disabling SATA Link Power Management (LPM) in GRUB
Message-ID: <20110608224527.21d2d911@mgi.gigerstyle.ch>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Devs,

I spent my Samsung RF511 Notebook a OCZ Vertex III SSD. Unfortunately
there seems to be an incompatibility between these. Samsung is not
willing to help me, because they won't support foreign Hard- (OCZ SSD)
and Software (Linux).

I've found the following forum entries which I think is the problem.
 
http://www.ocztechnologyforum.com/forum/showthread.php?88340-Vertex-3-Windows-install-in-AHCI-mode-on-Intel-6-series-Chipset-platforms

http://www.ocztechnologyforum.com/forum/showthread.php?88630-Vertex-3-problem-booting-windows-7-with-HM65-Sandybride-chips-%28Laptops%29/page3

It seems because of this GRUB has problem loading the stages from the
disk in my case.

So my question are:

1. Does this make sense to you? Is it possible that it could be the
reason?
2. Can the problem be solved when I implement a hack into GRUB to
disable the LPM before the stages are loaded from disk?
3. What are the implementation steps which must be done? When I
understand the code in the kernel correctly, the registers are
written over memory mapped areas. Can it be done without mmio?

Thanks a lot!

Kind Regards

Marc


-- 
Lesson 1: Cryptographic protocols should not be developed by a
committee. -- Niels Ferguson and Bruce Schneier --
