Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0HDSDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:03:30 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33533 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab0HDSD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:03:28 -0400
Date: Wed, 4 Aug 2010 11:03:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-net@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 2.6.35
Message-ID: <20100804110323.40439045@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of iproute2 utilities intended for use with 2.6.35 or
later kernel, but should be backward compatible with older releases.
In addition to build and man page fixes, this release includes a
support for a couple of new kernel features:

   * 64 bit network device stats
   * multicast rules

he tar ball is available at:
  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.35.tar.bz2

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

For more info on iproute2 see:
  http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

Changes since last release (2.6.34)

Andreas Henriksson (1):
      tc: make symbols loaded from tc action modules global.

Arnd Hannemann (1):
      iproute2: Add dsfield as alias for tos for ip rules

Ben Greear (1):
      iproute2: Fix batch-mode for mrules.

Jan Engelhardt (1):
      Add IFLA_STATS64 support

Mike Frysinger (3):
      tc: revert "echo" in install target
      dnet: fix strict aliasing warnings
      netem: fix installs of dist files

Patrick McHardy (1):
      ip: add support for multicast rules

Petr Lautrbach (1):
      iproute: fix tc generating ipv6 priority filter

Stephen Hemminger (5):
      Update kernel derived headers
      Update ARP header type table
      Fix NULL pointer reference when using basic match
      Fix byte order of ether address match for u32
      snapshot 100804

Steve Fink (1):
      ss -p is much too slow

Ulrich Weber (3):
      iproute2: filter routing entries based on clone flag
      iproute2: use get_user_hz() for IPv6 print_route
      iproute2: use int instead of long for RTAX_HOPLIMIT compare

