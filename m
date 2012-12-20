Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab2LTG6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:58:12 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55634 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LTG6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:58:06 -0500
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 20 Dec 2012 12:22:29 +0530
Message-ID: <CAO_48GEePPaGtEsSZR+e1TDULqSmoHe5S0=+wHu8A=hYj9hMMA@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        linux-media@vger.kernel.org
Cc: Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A fairly small dma-buf pull request for 3.8 - only 2 patches. Could
you please pull?

Thanks!
~Sumit.

The following changes since commit f01af9f85855e38fbd601e033a8eac204cc4cc1c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
(2012-12-19 20:31:02 -0800)

are available in the git repository at:


  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
tags/tag-for-linus-3.8

for you to fetch changes up to ada65c74059f8c104f1b467c126205471634c435:

  dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER (2012-12-20
12:05:06 +0530)

----------------------------------------------------------------
3.8: dma-buf minor updates

----------------------------------------------------------------
Maarten Lankhorst (1):
      dma-buf: remove fallback for !CONFIG_DMA_SHARED_BUFFER

Rob Clark (1):
      dma-buf: might_sleep() in dma_buf_unmap_attachment()

 drivers/base/dma-buf.c  |    2 +
 include/linux/dma-buf.h |   99 -----------------------------------------------
 2 files changed, 2 insertions(+), 99 deletions(-)
