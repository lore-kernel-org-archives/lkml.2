Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2ALI3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:29:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8695 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2ALI26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:28:58 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-78-4f0e99c988d5
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1326351429.3471.0.camel@phoenix>
In-reply-to: <1326351429.3471.0.camel@phoenix>
Subject: RE: [PATCH 1/2] regulator: s5m8767: Add missing breaks
Date: Thu, 12 Jan 2012 17:29:19 +0900
Message-id: <027001ccd104$47bdb0b0$d7391210$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczQ924gUy49PsOsRF+yTGVpwRc0QAACx0GQ
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 12, 2012 3:57 PM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against Mark's regulator tree (for-next-next branch).
> 
>  drivers/regulator/s5m8767.c |    4 ++++

During normal test, I can't detect the problem.
But It should add break to apply proper ramp slope.

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

