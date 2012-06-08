Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095Ab2FHKxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:53:47 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:33498 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761323Ab2FHKxp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <1339011882-7919-1-git-send-email-merez@codeaurora.org>
References: <1339011882-7919-1-git-send-email-merez@codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Fri, 8 Jun 2012 16:23:21 +0530
Message-ID: <CANfBPZ8C7YY760yx9ATi1_UJ_itL0N+fVdxx0Lim-55SgGjbng@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] block: Add test-iosched scheduler
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 1:14 AM, Maya Erez <merez@codeaurora.org> wrote:
> The test scheduler allows testing a block device by dispatching
> specific requests according to the test case and declare PASS/FAIL
> according to the requests completion error code
>
I can't get the point. Isn't this possible purely from userspace using IOCTLs ?
Even otherwise, requiring to modify the scheduler for each test case
is definitely not scalable.

> Changes in v2:
>    - Export test-iosched functionality to allow definition of the block device
>      tests under the block device layer
>    - Add registration of block device tests utilities
>
> Maya Erez (1):
>  block: Add test-iosched scheduler
>
>  Documentation/block/test-iosched.txt |   39 ++
>  block/Kconfig.iosched                |    8 +
>  block/Makefile                       |    1 +
>  block/blk-core.c                     |    3 +-
>  block/test-iosched.c                 | 1025 ++++++++++++++++++++++++++++++++++
>  include/linux/test-iosched.h         |  218 +++++++
>  6 files changed, 1292 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/block/test-iosched.txt
>  create mode 100644 block/test-iosched.c
>  create mode 100644 include/linux/test-iosched.h
>
