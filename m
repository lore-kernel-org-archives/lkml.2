Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab1IZEW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 00:22:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13141 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1IZEW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 00:22:56 -0400
X-AuditID: cbfee61b-b7b7fae000005864-dc-4e7ffe1ed16d
Date: Mon, 26 Sep 2011 13:22:54 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: Samsung GPIO changes break boot on Cragganmore
In-reply-to: <20110922135351.GC5173@opensource.wolfsonmicro.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-id: <00d301cc7c03$f6813230$e3839690$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acx5LxKjz4yJu5fwQb+8EZJpmB2AXwCvDkOw
References: <20110922135351.GC5173@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> Hi,
> 
> Something in the recent GPIO changes have broken the boot for me on
> Cragganmore (S3C6410 based) systems.  The boot dies before any console
> output is produced so it's hard to isolate exactly what went wrong but
> backing out:
> 
>    5ec7414 ARM: SAMSUNG: Remove useless Samsung GPIO related CONFIGs
>    7c15788 ARM: SAMSUNG: Update the name of regarding Samsung GPIO
>    bedcda6 gpio/samsung: gpio-samsung.c to support Samsung GPIOs
> 
> fixes the system boot for me.  The diff is rather substantial so it's
> hard to check by eyeball unfortunately.
> 
Hi Mark,

Oh, ok. Let me test on SMDK6410 and will fix soon.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

