Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122Ab2KAKHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:07:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161031Ab2KAKHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:07:38 -0400
X-AuditID: cbfee61b-b7f616d00000319b-ae-509249e8a87d
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Sergei Trofimovich'" <slyich@gmail.com>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Sergei Trofimovich'" <slyfox@gentoo.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1351635712-17214-1-git-send-email-slyich@gmail.com>
In-reply-to: <1351635712-17214-1-git-send-email-slyich@gmail.com>
Subject: RE: [PATCH] exynos: mmc: use correct variable for MODULE_DEVICE_TABLE
Date: Thu, 01 Nov 2012 19:07:36 +0900
Message-id: <010401cdb818$b7912100$26b36300$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac227QH1PrrtKXiZSh2w7TGBCEss3ABHTBxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd0XnpMCDG6/kbS4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX8WjGBpWAmW8Xcf61MDYxzWbsYOTgkBEwknq8162Lk
	BDLFJC7cW88GYgsJLGKUuL2fA8L+wyjxcbIviM0moCXx980bZhBbRMBLYsXRBsYuRi4OZoGD
	jBJTpy1kgWhwkNh44BYTyHxOAUeJ48fTQMLCAn4Sy/5sZwSxWQRUJdp/7wMr5xWwlZj75wIT
	hC0o8WPyPbA4s4CBxPtZfawQtrzE5jVvmSFOVpd49FcX4gQjiUkPXrBDlIhI7HvxjnECo9As
	JJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuZn0jsYVzVYHGIU
	4GBU4uGdUDcxQIg1say4MvcQowQHs5II7+NuoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+U
	ACGB9MSS1OzU1ILUIpgsEwenVAOjhY5CZLXfRomj/9zP8dn9Fngd1PEo79znI0zL2q4Yr/We
	Gbzv1pS/H+/Jic19eKnee6LVjAU3pmTdyQ28OkNi/6ndGv+cHn250arm6fb0h+p7qQ9PNjJs
	8Le5K3cgda7p/h2Xkr3OarermK6zbZ+gYlajmmZsXNdbwJ0gutbnZkfFA7cv6scuKLEUZyQa
	ajEXFScCANQF48xiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012, Sergei Trofimovich <slyfox@gentoo.org> wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by gcc:
> 
>     linux-2.6/drivers/mmc/host/dw_mmc-exynos.c: At top level:
>     linux-2.6/drivers/mmc/host/dw_mmc-exynos.c:226:1: error: '__mod_of_device_table' aliased to
> undefined symbol 'dw_mci_pltfm_match'
> 
> CC: Chris Ball <cjb@laptop.org>
> CC: Thomas Abraham <thomas.abraham@linaro.org>
> CC: Will Newton <will.newton@imgtec.com>
> CC: linux-mmc@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

I suggest changing the prefix of subject.
'mmc: dw_mmc-exynos' instead of 'exynos: mmc'

Thanks,
Seungwon Jeon


