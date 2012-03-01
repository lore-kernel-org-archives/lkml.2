Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2CAPW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:22:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58259 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab2CAPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:22:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.vetter@ffwll.ch designates 10.180.87.8 as permitted sender) smtp.mail=daniel.vetter@ffwll.ch; dkim=pass header.i=daniel.vetter@ffwll.ch
MIME-Version: 1.0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/3] [RFC] kernel cpu access support for dma_buf
Date: Thu,  1 Mar 2012 16:35:58 +0100
Message-Id: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series here implements an interface to enable cpu access from the kernel
context to dma_buf objects. The main design goal of this interface proposal is
to enable buffer objects that reside in highmem.

Comments, flames, ideas and questions highly welcome. Althouhg I might be a bit
slow in responding - I'm on conferences and vacation the next 2 weeks.

Cheers, Daniel

Daniel Vetter (3):
  dma-buf: don't hold the mutex around map/unmap calls
  dma-buf: add support for kernel cpu access
  dma_buf: Add documentation for the new cpu access support

 Documentation/dma-buf-sharing.txt |  102 +++++++++++++++++++++++++++++-
 drivers/base/dma-buf.c            |  124 +++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h           |   62 ++++++++++++++++++-
 3 files changed, 280 insertions(+), 8 deletions(-)

-- 
1.7.7.5

