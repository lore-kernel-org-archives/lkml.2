Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1JCGtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:49:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9065 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1JCGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:48:56 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-d6-4e895ad60442
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-6-git-send-email-arnd@arndb.de>
 <20111002204729.GC5811@opensource.wolfsonmicro.com>
 <3289863.m6ULFZUV3p@wuerfel>
In-reply-to: <3289863.m6ULFZUV3p@wuerfel>
Subject: RE: [alsa-devel] [PATCH 5/6] ASoC: samsung: fix Kconfig dependencies
Date: Mon, 03 Oct 2011 15:48:54 +0900
Message-id: <004e01cc8198$848347f0$8d89d7d0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyBSHlS6nbfC4PURjyN4s7L5omUwgAS0swQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Oct 03, 2011 at 6:15:03AM , Arnd Bergmann wrote:
> It's a bug that I only observed on exynos4, and it could be that
> this patch didn't actually solve it in the end. I'll drop it for
> now and do a better report when the problem comes back.

Could you please explain problem which observed on exynos4?
If possible, I want to check it too.

Thanks

Sangbeom.

