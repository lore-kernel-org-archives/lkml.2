Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0DTShi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:37:38 -0400
Received: from a2s43.a2hosting.com ([69.39.89.30]:60780 "EHLO
	a2s43.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0DTShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:37:37 -0400
X-Greylist: delayed 20841 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 14:37:37 EDT
Date: Tue, 20 Apr 2010 08:52:30 -0400
From: Michael Shell <list1@michaelshell.org>
To: linux-kernel@vger.kernel.org
Subject: CD/DVD-R eject after burn to sync/validate/update read cache and/or
 media flags
Message-ID: <20100420085230.46608b34@bashir>
X-Mailer: Sylpheed-Claws 2.3.1 (GTK+ 2.4.9; i586-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s43.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - michaelshell.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



We recently had a discussion on the cdrecord-support mailing list
about the need to eject a CD/DVD-R after burning to be able to
mount it.

This has been a known issue under Linux for some time:

http://lkml.indiana.edu/hypermail/linux/kernel/0705.0/0259.html

http://lkml.indiana.edu/hypermail/linux/kernel/9604.3/0377.html

It is a more serious annoyance with laptop drives that cannot
close their trays without the help of a human hand.

Has this issue been fixed in recent kernels, and if so, does anyone
know about what release the change was made?

Also, is there an ioctl or other way to force the kernel/driver to
invalidate the read cache or other stored data of a specific
drive/media (not the system as a whole) without having to physically
eject the media?


  Cheers and thanks in advance,

  Mike Shell



