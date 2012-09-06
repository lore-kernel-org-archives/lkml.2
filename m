Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2IFWD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:03:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44946 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IFWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:03:56 -0400
X-AuditID: cbfee61b-b7f056d000002c30-52-50491dca8bef
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        dong.aisheng@linaro.org, patches@linaro.org
References: <226e01cd8ae6$928010b0$b7803210$%kim@samsung.com>
 <1346826046-30484-1-git-send-email-thomas.abraham@linaro.org>
 <5048DE83.4050203@wwwdotorg.org>
In-reply-to: <5048DE83.4050203@wwwdotorg.org>
Subject: RE: [PATCH v3 1/4] pinctrl: add samsung pinctrl and gpiolib driver
Date: Fri, 07 Sep 2012 07:03:53 +0900
Message-id: <241701cd8c7b$81022580$83067080$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2MVc4CnFyKVWjFQGSWggWdBwoQ1wAIz8aA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd1Tsp4BBnsfi1hc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU8mm1W8Iiz4tOVI+wNjL/Yuxg5OSQETCSa+48xQdhi
	EhfurWfrYuTiEBJYxCjx+N1FdgjnL6PE03OtzCBVbAIaEoffPwPrFhGIkdh0oxGsm1mgn0ni
	6Lc4EFtIYAGjxMGVkiA2p4CuxNpTfSwgtrCAt8TKxU/AelkEVCWaehczdjFycPAK2Eo0LyoF
	CfMKCEr8mHyPBWKklsT6ncehxstLbF7zlhmkXEJAXeLRX12IC4wkHq/eywpRIiKx78U7xgmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4nJ9J72Bc1WBx
	iFGAg1GJh9fiikeAEGtiWXFl7iFGCQ5mJRHeib+AQrwpiZVVqUX58UWlOanFhxilOViUxHmd
	ztkFCAmkJ5akZqemFqQWwWSZODilGhhdg9Zd7Z+72onhvPm35oc2+RUXlHte/7NpWtujx32H
	4bLAm7VfNhWs0jllF5GyYu/E/xwRW8383ASzfpzarqAQNLNzz+xNScF/JOrc9KqPFn3+0fZO
	9fTNSu27lrxTmyu/f4w++klyrcLjd7KTxQIF9/7gCX3P0JcSWiVTzDHz2XfvVW3hcd5KLMUZ
	iYZazEXFiQBI9MOwYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote:
> 
> On 09/05/2012 12:20 AM, Thomas Abraham wrote:
> > Add a new device tree enabled pinctrl and gpiolib driver for Samsung
> > SoC's. This driver provides a common and extensible framework for all
> > Samsung SoC's to interface with the pinctrl and gpiolib subsystems. This
> > driver supports only device tree based instantiation and hence can be
> > used only on those Samsung platforms that have device tree enabled.
> >
> > This driver is split into two parts: the pinctrl interface and the
> gpiolib
> > interface. The pinctrl interface registers pinctrl devices with the
> pinctrl
> > subsystem and gpiolib interface registers gpio chips with the gpiolib
> > subsystem. The information about the pins, pin groups, pin functions and
> > gpio chips, which are SoC specific, are parsed from device tree node.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Applied this whole series, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

