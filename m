Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2GSQYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:24:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33898 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2GSQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:24:47 -0400
From: Rob Clark <rob.clark@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: patches@linaro.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
        t.stanislaws@samsung.com, sumit.semwal@ti.com,
        maarten.lankhorst@canonical.com, Rob Clark <rob@ti.com>
Subject: [PATCH 0/2] dma-parms and helpers for dma-buf
Date: Thu, 19 Jul 2012 11:23:32 -0500
Message-Id: <1342715014-5316-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

Re-sending first patch, with a wider audience.  Apparently I didn't
spam enough inboxes the first time.

And, at Daniel Vetter's suggestion, adding some helper functions in
dma-buf to get the most restrictive parameters of all the attached
devices.

Rob Clark (2):
  device: add dma_params->max_segment_count
  dma-buf: add helpers for attacher dma-parms

 drivers/base/dma-buf.c      |   63 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h      |    1 +
 include/linux/dma-buf.h     |   19 +++++++++++++
 include/linux/dma-mapping.h |   16 +++++++++++
 4 files changed, 99 insertions(+)

-- 
1.7.9.5

