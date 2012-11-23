Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2KWPfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:35:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36684 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2KWPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:35:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-9c-50af97d111ca
From: Tomasz Figa <t.figa@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com
Subject: Re: [PATCH 0/3] regulator: max8997: minor updates and device tree
 support
Date: Fri, 23 Nov 2012 16:35:41 +0100
Message-id: <2301414.MvZtGCMDhm@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.3 (Linux/3.6.6-gentoo; KDE/4.9.3; x86_64; ; )
In-reply-to: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQd2L09cHGPzcK2NxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJVx9d4FxoKDXBV7Vj1gbmD8x97FyMEhIWAicfVzehcj
	J5ApJnHh3no2EFtIYDqjRMfx1C5GLiC7hUni05eNLCAJNgE1ic8Nj8CKRAT0JA4+/cgKUsQs
	cIhR4tf8qUwgCWGBEIkFr3azgtgsAqoSK1sfg9m8ApoSN1t+sYPY/ALqEu+2PQWrFxVwllh0
	eAcjiM0p4Clx9Hw/M8hxQgIeEn8fhEK0Ckr8mHwP7AZmAXmJffunskLYWhLrdx5nmsAoOAtJ
	2SwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERygz6R3MK5qsDjEKMDBqMTD
	a1i2LkCINbGsuDIX6EEOZiUR3q8V6wOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQn
	lqRmp6YWpBbBZJk4OKUaGKffY/sryBfGU3q6g93b1PHstTWPuWZNY7YICbgqH5+kv5GFM+Y6
	d+MWfh6HxsYTuYXzff9kVjyo+a3pzb+57p3IOYclE9P5+E6zGa8NYy/J+PFWcKNyo/HFr3li
	fjbWbFNzwhod9wmV+f0pST3uXTLh6/rSz/lz7B6vbip7rBqvf/2V4vYpSizFGYmGWsxFxYkA
	KBWdXEwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 of November 2012 13:33:12 Thomas Abraham wrote:
> This patch series includes two minor updates to the gpio dvs code in
> max8997 regulator driver and adds device tree support for the same
> driver.
> 
> Thomas Abraham (3):
>   regulator: max8997: reorder buck1/2/5 dvs setup code
>   regulator: max8997: limit the number of dvs registers programmed in
> non-dvs mode regulator: add device tree support for max8997
> 
>  .../bindings/regulator/max8997-regulator.txt       |  146
> ++++++++++++++++ drivers/mfd/max8997.c                              |  
> 73 ++++++++- drivers/regulator/max8997.c                        |  181
> ++++++++++++++++++-- include/linux/mfd/max8997-private.h               
> |    1 +
>  include/linux/mfd/max8997.h                        |    1 +
>  5 files changed, 384 insertions(+), 18 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/regulator/max8997-regulator.txt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

For whole series:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

