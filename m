Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab2JLUCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:02:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52973
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab2JLUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:02:07 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] Drivers: hv: vmbus 
Date: Fri, 12 Oct 2012 13:22:15 -0700
Message-Id: <1350073335-10575-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in the error path of vmbus_open(). As part of this also
get rid of some unnecessary forward declarations as well as empty
functions. I would like to thank Jason Wang <jasowang@redhat.com>
for reporting the issues.

K. Y. Srinivasan (3):
  Drivers: hv: Get rid of unnecessary forward declarations
  Drivers: hv: Cleanup error handling in vmbus_open()
  Drivers: hv: Get rid of hv_ringbuffer_cleanup()

 drivers/hv/channel.c      |   36 +++++++++++++-----------------------
 drivers/hv/hyperv_vmbus.h |    1 -
 drivers/hv/ring_buffer.c  |   11 -----------
 3 files changed, 13 insertions(+), 35 deletions(-)

-- 
1.7.4.1

