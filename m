Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0JUXfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:35:47 -0400
Received: from smtp14.ono.com ([62.42.230.176]:11565 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360Ab0JUXfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:35:46 -0400
Date: Fri, 22 Oct 2010 01:35:44 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CIFS is slooow, gvfs is fast
Message-ID: <20101022013544.0fdab0e0@werewolf.home>
X-Mailer: Claws Mail 3.7.6cvs54 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a very strange behaviour with windows networking.
I have an HTPC, which I access from my Linux desktop. It runs Windows 7.
Network is GigaBit, routed by a Linksys WRT320N running latest DD-WRT.
I setup an automount path under /net/htpc with CIFS filesystem.
I can also access the drives in HTPC via gvfs from Gnome DE.

Problem: speed is _VERY_ different.
R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridiculous
for gigabit speeds).
R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 Mbits/s),
that look much better.

I have tried with different rsize/wsize in mount, but speed is the same
(perhaps I did not get the right values...).

BTW, I'm not alone:

http://ubuntuforums.org/showthread.php?t=1578068
http://ubuntuforums.org/showthread.php?t=1429532
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/471512

but I have not seen any diagnostic anywere.

Any ideas ?

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
