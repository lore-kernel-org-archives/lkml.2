Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0FGJW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:22:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:35592 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752293Ab0FGJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:22:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/rDDoIBSnrvGYK67zD5tJwsDGUBwD0VhEA/j5KD6
	WkiyknaPKi+KE5
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: ThinkPad T400 : should kernel option "reboot=pci" be hard coded ?
Date: Mon, 7 Jun 2010 11:22:21 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Message-Id: <201006071122.21925.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since some kernel version (IIRC since 2.6.31) it is necessary to boot the 
linux kernel with that option to prevent an extra 9 seconds delay during 
reboot.
I found this tip on the LKML -and now I'm wondering whether this option should 
be hard coded in the kernel sources b/c it seems to be necessary for current 
kernels too.


-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

