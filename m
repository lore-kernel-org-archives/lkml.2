Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1L1AJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:09:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61407 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1L1AJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:09:41 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-c3-4efa5e43a76a
From: Sangbeom Kim <sbkim73@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
References: <1324971386-4447-1-git-send-email-sbkim73@samsung.com>
 <1324971386-4447-2-git-send-email-sbkim73@samsung.com>
In-reply-to: <1324971386-4447-2-git-send-email-sbkim73@samsung.com>
Subject: RE: [PATCH v3] regulator: Add S5M8767 regulator driver
Date: Wed, 28 Dec 2011 09:09:39 +0900
Message-id: <05a301ccc4f4$fda97fb0$f8fc7f10$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczEyy7UjIF/FZmWRcmQaBVGMlRjDgAJgafQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 4:36 PM, Sangbeom Kim wrote:

> S5M8767 is a cost-effective PMIC which is designed for mobile
applications.
> It includes high efficient 9 Buck converters, 28 LDOs.
> This patch implement regulator driver for S5M8767.
> 
> Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
> ---
>  drivers/regulator/s5m8767.c |  878
> +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 878 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/s5m8767.c

Hi!,
This 3rd patch for S5M8767A regulator driver.
My git server has some problem.
0 patch is disappeared or will be delivered after few days.
So, I wrote here about v3 change things.

Changes since v2:
As Mark Brown comments
- Implement get_voltage_sel
- Implement set_voltage_time_sel
- Replace kzalloc with devm_kzalloc
- Fix indentation error
- minor changes...

Thanks,

