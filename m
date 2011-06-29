Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1F2I1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:27:46 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61455 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1F2I1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:27:43 -0400
Message-ID: <4E0AE1FC.3070201@imgtec.com>
Date: Wed, 29 Jun 2011 09:27:40 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, Will <will.newton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] mmc: dw_mmc: mmc_test related fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2011 08:27:40.0978 (UTC) FILETIME=[694E6120:01CC3636]
X-SEF-Processed: 7_3_0_01158__2011_06_29_09_27_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More improvements and fixes for the Synopsys DesignWare MCI driver so
that it passes the mmc_test suite:

[PATCH 1/4] mmc: dw_mmc: fix stop when fallen back to PIO
	Fixes a hang after an error/timeout in PIO mode.
[PATCH 2/4] mmc: dw_mmc: remove unnecessary error messages
	Removes some dev_err's since an errno is sufficient.
[PATCH 3/4] mmc: dw_mmc: handle "no CRC status" error
	Fixes "Correct xfer_size at write" tests.
[PATCH 4/4] mmc: dw_mmc: reset FIFO after an error
	Fixes modified "Correct xfer_size at write" tests (3 blocks
	instead of 2).
 
 drivers/mmc/host/dw_mmc.c  |   41 +++++++++++++++++++++++++++++++----------
 include/linux/mmc/dw_mmc.h |    2 ++
 2 files changed, 33 insertions(+), 10 deletions(-)

