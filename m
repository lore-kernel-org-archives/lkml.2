Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1KIFIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:08:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28404 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1KIFIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:08:37 -0500
X-AuditID: cbfee61b-b7b7fae000005864-11-4eba0ad3b61b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
References: <20111109082624.ea5697763c50ef9128244783@canb.auug.org.au>
In-reply-to: <20111109082624.ea5697763c50ef9128244783@canb.auug.org.au>
Subject: RE: linux-next: incorrect build fix
Date: Wed, 09 Nov 2011 14:08:35 +0900
Message-id: <001e01cc9e9d$a26dca20$e7495e60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyeXRgTCsSZCYyPSauSwdHolbl03QAQF+Xw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi,
> 
Hi Stephen,

> I noticed in commit 8644c202ff42 ("ARM: EXYNOS: Fix compiler error with
> THIS_MODULE") in the s5p tree, an include of linux/module.h is used to
> get THIS_MODULE. For THIS_MODULE, you only need to include
> linux/export.h, now.  To fix the other errors that were fixed by side
> effects of including module.h, you should include linux/time.h (for
> struct timeval, USEC_PER_SEC and do_gettimeofday).
> 
OK, I will fix it in my tree.

> Please try a bit harder to get these things right.

Thanks for your pointing out :)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

