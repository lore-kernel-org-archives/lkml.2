Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2HGINm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:13:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32640 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2HGINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:13:39 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-11-5020ce2c849a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: "'Dongjin Kim'" <dongjin.kim@agreeyamobility.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <CACRpkdbe95qj1hpZCNRZsLjC7s_N8NgLKrXk=p6gXZDDrj_P8g@mail.gmail.com>
In-reply-to: <CACRpkdbe95qj1hpZCNRZsLjC7s_N8NgLKrXk=p6gXZDDrj_P8g@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: Add gpio functions for Exynos4412
Date: Tue, 07 Aug 2012 17:13:31 +0900
Message-id: <097601cd7474$889dbe40$99d93ac0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10Z0FSRmfhlWy5QPuDVET3w2qHuQADJIcg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAV2dcwoBBn0z+C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG142XrAV/WCserj7D3sD4mqWLkZNDQsBEYkPbRCYIW0ziwr31
	bF2MXBxCAosYJV7t/8gMkhASmMcksbbTHcRmE9CQOPz+GTuILSLQwihx6lwiSAOzwEZGibm3
	2hkhuqcxSsxZM50NpIpTIFhi8cdjYB3CAs4Sr1ZsZQSxWQRUJY6/nQ4W5xWwlVi07A4zhC0o
	8WPyPbDzmAW0JNbvPM4EYctLbF7zFqiGA+hUdYlHf3UhjjCSeLzrPiNEiYjEvhfvGCcwCs1C
	MmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgUH4mtYNxZYPFIUYB
	DkYlHt4JsgoBQqyJZcWVuYcYJTiYlUR4D+8ECvGmJFZWpRblxxeV5qQWH2KU5mBREuc19v7q
	LySQnliSmp2aWpBaBJNl4uCUamA00VTqZtyTyxLuc+LmlGcq1WKWdydsnrrxi+lZ1euMQVef
	+d2Z8OYTr/Ojzti+ZIv9kscret79ypB2OrJhTc8ZXw5R08CjKk9jDumLtD60sdn/4fXH1BTB
	uREFxQ/flFktffLqUGzmeokJnA7WkRcmObatfsL3M4H35gub57w7C7bW5z/I7uZSYinOSDTU
	Yi4qTgQA6pgGtGECAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Mon, Aug 6, 2012 at 3:57 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> 
> > GPIO functions are not registered for Exynos4412 yet,
> > therefore exynos4_gpiolib_init() is added to initialize Exynos4412 SoC.
> >
> > Change-Id: I5945d94c6fbfc309ccf882eba067864a338c04ca
> 
> Gerrit change ID:s are not used in the kernel.
> 
> > Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> 
> I'd like to have some Samsung feedback on this patch...
> 
Well, current gpio-samsung.c cannot support EXYNOS4412 yet, so I'd like to
request that you don't apply this.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

