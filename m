Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1IATF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:05:58 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46309
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756837Ab1IATF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:05:57 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 15:05:57 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 00/10] netvsc bug fixes and cleanups
Date: Thu,  1 Sep 2011 12:19:38 -0700
Message-Id: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a set of bugs in netvsc module, and cleaned up some coding style issues.

Haiyang Zhang (10):
  staging: hv: remove unnecessary includes in netvsc
  staging: hv: add newline to log messages in netvsc
  staging: hv: convert dev_<loglevel> to netdev_<loglevel> in netvsc
  staging: hv: fix a kernel warning in netvsc_linkstatus_callback()
  staging: hv: re-order the code in netvsc_probe()
  staging: hv: fix counting of #outstanding-sends in failed sends
  staging: hv: fix counting of available buffer slots when send fails
  staging: hv: fix the return status of netvsc_start_xmit()
  staging: hv: fix the page buffer when rndis data go across page
    boundary
  staging: hv: fix some typos in netvsc.c

 drivers/staging/hv/netvsc.c       |  124 ++++++++++++++++++++-----------------
 drivers/staging/hv/netvsc_drv.c   |   44 +++++++------
 drivers/staging/hv/rndis_filter.c |   28 ++++++---
 3 files changed, 110 insertions(+), 86 deletions(-)

