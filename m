Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1HPCj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:39:29 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60836 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004Ab1HPCj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:39:28 -0400
X-Sasl-enc: 4N0dkqME0gfPlDHU5cn0vJk76RoGUjw6RVMYgP9HBMtj 1313462367
Date: Mon, 15 Aug 2011 19:38:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.18
Message-ID: <20110816023809.GA1858@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.18 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

Note, as the -rt tree should soon be "stable" and based off of the 3.0
kernel release, it is unknown how much longer I will be maintaining this
branch.  You have been forwarned.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/powerpc/kernel/prom_init.c          |    6 
 arch/powerpc/platforms/pseries/lpar.c    |    2 
 crypto/md5.c                             |   92 --------
 drivers/char/random.c                    |  334 -------------------------------
 include/linux/cryptohash.h               |    5 
 include/linux/random.h                   |   11 -
 include/net/secure_seq.h                 |   20 +
 lib/Makefile                             |    2 
 lib/md5.c                                |   95 ++++++++
 net/core/Makefile                        |    2 
 net/core/secure_seq.c                    |  184 +++++++++++++++++
 net/dccp/ipv4.c                          |    1 
 net/dccp/ipv6.c                          |    9 
 net/ipv4/inet_hashtables.c               |    1 
 net/ipv4/inetpeer.c                      |    1 
 net/ipv4/netfilter/nf_nat_proto_common.c |    1 
 net/ipv4/route.c                         |    1 
 net/ipv4/tcp_ipv4.c                      |    1 
 net/ipv6/inet6_hashtables.c              |    1 
 net/ipv6/tcp_ipv6.c                      |    1 
 sound/core/timer.c                       |    2 
 sound/usb/caiaq/input.c                  |    2 
 23 files changed, 333 insertions(+), 443 deletions(-)

Anton Blanchard (2):
      powerpc: Fix device tree claim code
      powerpc: pseries: Fix kexec on machines with more than 4TB of RAM

Daniel Mack (1):
      ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3

David S. Miller (2):
      crypto: Move md5_transform to lib/md5.c
      net: Compute protocol sequence numbers and fragment IDs using MD5.

Greg Kroah-Hartman (1):
      Linux 2.6.33.18

Takashi Iwai (1):
      ALSA: timer - Fix Oops at closing slave timer

