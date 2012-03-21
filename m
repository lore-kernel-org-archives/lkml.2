Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2CUVP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:15:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35384 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2CUVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:15:26 -0400
Date: Wed, 21 Mar 2012 14:15:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 0/8] 3.0.26-stable review
Message-ID: <20120321211522.GA28233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.26 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Mar 23 21:14:47 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.26-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                     |    4 ++--
 arch/powerpc/platforms/powermac/smp.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    7 +++---
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    2 +-
 fs/afs/internal.h                            |    2 +-
 fs/afs/rxrpc.c                               |    3 +++
 fs/nilfs2/the_nilfs.c                        |    1 +
 net/ipv4/syncookies.c                        |   30 ++++++++++++++------------
 net/ipv4/tcp_ipv4.c                          |   10 ++++++---
 net/ipv6/mcast.c                             |    1 -
 tools/perf/util/sort.c                       |    3 +++
 11 files changed, 39 insertions(+), 26 deletions(-)

