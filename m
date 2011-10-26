Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab1JZNBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:01:00 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:25671 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932987Ab1JZNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:00:59 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 09:00:59 EDT
Message-ID: <42295.128.173.192.90.1319633510.squirrel@webmail.tuffmail.net>
Date: Wed, 26 Oct 2011 08:51:50 -0400 (EDT)
Subject: initrd image size of 3.1.0 kernel
From: "Brad Tilley" <brad@16systems.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I built a vanilla stable kernel using the most recent 3.1.0 stable source.
I built it like this:

make silentoldconfig
make deb-pkg

The kernel boots and runs fine. However, the size (greater than 100 MB) of
the initrd image surprised me. Doing the same sort of build for a 3.0.x
kenerl produces a much smaller image:

-rw-r--r--  1 root root  12M Sep  6 11:57 initrd.img-3.0.4
-rw-r--r--  1 root root 107M Oct 26 08:03 initrd.img-3.1.0

I only want to point this out. Perhaps I missed something in the
documentation that explains the size difference, or something in my old
config or toolset caused it. Here are some versions installed on my
system:

gcc (Debian 4.4.5-8) 4.4.5
GNU Make 3.81
GNU ld (GNU Binutils for Debian) 2.20.1-system.20100303
fdformat (util-linux-ng 2.17.2)
module-init-tools 3.12
grub-install (GRUB) 1.98+20100804-14+squeeze1

I'm not subscribed, so please CC if you wish for me to see the replies or
if you would like more info.

If this larger size is normal (not an error on my part) then /boot sizes
will need to grow to accommodate this.

Brad





