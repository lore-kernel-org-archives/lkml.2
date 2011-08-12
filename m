Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1HLVLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:11:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41146 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab1HLVLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:11:00 -0400
X-Sasl-enc: CkJTQvkSmR3ECccx3Hs2QRuzVOIVvVry6b58DofCGDGU 1313183459
Date: Fri, 12 Aug 2011 14:08:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/6] 2.6.32.45-longterm review
Message-ID: <20110812210849.GA5640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.45 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 15, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.45-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                 |    2 +-
 arch/powerpc/kernel/prom_init.c          |    6 +-
 arch/powerpc/platforms/pseries/lpar.c    |    2 +-
 crypto/md5.c                             |   92 +--------
 drivers/char/random.c                    |  334 +-----------------------------
 include/linux/cryptohash.h               |    5 +
 include/linux/random.h                   |   11 -
 include/net/secure_seq.h                 |   20 ++
 lib/Makefile                             |    2 +-
 lib/md5.c                                |   95 +++++++++
 net/core/Makefile                        |    2 +-
 net/core/secure_seq.c                    |  184 ++++++++++++++++
 net/dccp/ipv4.c                          |    1 +
 net/dccp/ipv6.c                          |    9 +-
 net/ipv4/inet_hashtables.c               |    1 +
 net/ipv4/inetpeer.c                      |    1 +
 net/ipv4/netfilter/nf_nat_proto_common.c |    1 +
 net/ipv4/route.c                         |    1 +
 net/ipv4/tcp_ipv4.c                      |    1 +
 net/ipv6/inet6_hashtables.c              |    1 +
 net/ipv6/tcp_ipv6.c                      |    1 +
 sound/core/timer.c                       |    2 +
 sound/usb/caiaq/input.c                  |    2 +-
 23 files changed, 333 insertions(+), 443 deletions(-)
