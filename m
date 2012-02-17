Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2BQA5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:57:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48312 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab2BQA46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:56:58 -0500
X-Sasl-enc: bm6VlSB0BMFVXS4Kg7Nvm7JVNXmn6OJoyV1M4DeCwo4j 1329440217
Date: Thu, 16 Feb 2012 16:56:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/15] 3.0.22-stable review
Message-ID: <20120217005650.GA17119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.22 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 19 00:55:09 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.22-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                 |    4 +-
 arch/x86/pci/xen.c                       |    2 +-
 crypto/sha512_generic.c                  |   70 ++++++++++++++----------------
 drivers/gpio/pca953x.c                   |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c        |    8 +++
 drivers/hwmon/f75375s.c                  |    4 +-
 include/linux/proportions.h              |    4 ++
 include/trace/events/writeback.h         |    5 ++-
 kernel/relay.c                           |   10 +++-
 mm/slub.c                                |    6 +++
 net/mac80211/rx.c                        |    2 +-
 sound/pci/intel8x0.c                     |    6 +++
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 +++
 tools/perf/util/evsel.c                  |    1 +
 14 files changed, 85 insertions(+), 49 deletions(-)

