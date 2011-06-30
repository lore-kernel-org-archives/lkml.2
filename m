Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1F3F0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:26:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1F3F0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:26:50 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-15-4e0c0917a162
Date: Thu, 30 Jun 2011 14:26:48 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH 0/4] mmc: dw_mmc: mmc_test related fixes
In-reply-to: <BANLkTimAwoDybg8TdbMa6rjFY9H9vzGnHg@mail.gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4E0C0918.1080006@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
References: <4E0AE1FC.3070201@imgtec.com>
 <BANLkTimAwoDybg8TdbMa6rjFY9H9vzGnHg@mail.gmail.com>
X-OriginalArrivalTime: 30 Jun 2011 05:27:01.0852 (UTC)
 FILETIME=[5718C1C0:01CC36E6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Jaehoon Chung <jh80.chung@samsung.com>

Will Newton wrote:
> On Wed, Jun 29, 2011 at 9:27 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> More improvements and fixes for the Synopsys DesignWare MCI driver so
>> that it passes the mmc_test suite:
>>
>> [PATCH 1/4] mmc: dw_mmc: fix stop when fallen back to PIO
>>        Fixes a hang after an error/timeout in PIO mode.
>> [PATCH 2/4] mmc: dw_mmc: remove unnecessary error messages
>>        Removes some dev_err's since an errno is sufficient.
>> [PATCH 3/4] mmc: dw_mmc: handle "no CRC status" error
>>        Fixes "Correct xfer_size at write" tests.
>> [PATCH 4/4] mmc: dw_mmc: reset FIFO after an error
>>        Fixes modified "Correct xfer_size at write" tests (3 blocks
>>        instead of 2).
>>
>>  drivers/mmc/host/dw_mmc.c  |   41 +++++++++++++++++++++++++++++++----------
>>  include/linux/mmc/dw_mmc.h |    2 ++
>>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> These all look good to me.
> 
> Acked-by: Will Newton <will.newton@imgtec.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

