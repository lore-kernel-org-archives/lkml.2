Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2LNMJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 07:09:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2LNMJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 07:09:17 -0500
X-AuditID: cbfee61b-b7f616d00000319b-91-50cb16eb3838
From: Tomasz Figa <t.figa@samsung.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] gpio: samsung: remove exynos_gpio_cfg
Date: Fri, 14 Dec 2012 13:09:10 +0100
Message-id: <135551836.smSUskQTBC@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.3 (Linux/3.5.7-gentoo; KDE/4.9.3; x86_64; ; )
In-reply-to: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
References: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd3XYqcDDLZsNbe4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4vb+PqWAzS0V/93G2BsYTzF2MnBwSAiYSDTM6oGwx
	iQv31rN1MXJxCAksYpQ4ffYKE0hCSKCFSWLVWRsQm01ATeJzwyOgIg4OEQEdiQ0n2UHqmQXW
	MUp0TfnEDlIjLGAl8fvUMrBeFgFVie89N1hA6nkFtCWa71WDhPkF1CXebXsKViIq4Cyx7/oH
	RhCbU8BD4sLBNjaIte4SV/umg9XwCghK/Jh8jwXEZhaQl9i3fyorhK0lsX7ncaYJjIKzkJTN
	QlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBAfpMegfjqgaLQ4wCHIxKPLwf
	hE4FCLEmlhVX5h5ilOBgVhLh/SJyOkCINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpi
	SWp2ampBahFMlomDU6qBUaunZsLuppW3p12fcvjAtj8rZc0XSumHv26KkJRaX7k7f+5NDr4C
	36+/sl4kieyenLJ/rWqZxBOfifEWe79un38/LuD2veDP/8QZu9iZg44kL/omPCOL/7BIYrPS
	K0vzmNV8bRb91hazZ05MdHY5OWF58Hv5orQ24Y6AifelAljfvHm+/3jvWiWW4oxEQy3mouJE
	APHaGOZMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung,

On Friday 14 of December 2012 19:44:01 Joonyoung Shim wrote:
> The exynos_gpio_cfg can be substituted to samsung_gpio_cfgs[8].
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Since recently Thomas Abraham posted patches for pin control support of 
Exynos5250, basically making the legacy GPIO support useless, I think 
there is no need to extend it.

Instead existing boards should be made to use the pinctrl driver.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

