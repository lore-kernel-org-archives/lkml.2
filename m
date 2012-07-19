Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2GSWrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:47:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2GSWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:47:35 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-b9-50088e86aadb
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
 <5008279B.4000001@samsung.com>
 <CAJuYYwQBgpJ1wiS3fSDS2cMi6kanuO47rc8SmniAqjRPuBGJHg@mail.gmail.com>
In-reply-to: <CAJuYYwQBgpJ1wiS3fSDS2cMi6kanuO47rc8SmniAqjRPuBGJHg@mail.gmail.com>
Subject: RE: [PATCH v3 0/6] mmc: dw_mmc: add support for device tree based
 instantiation
Date: Fri, 20 Jul 2012 07:47:34 +0900
Message-id: <195201cd6600$7cb089f0$76119dd0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1l4JYplAZUycenT5KG5q6TdoSKEgAH21yw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd22Po4Ag8b3AhaXd81hszjyv5/R
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZXzsXM9WcJqjYuGr/UwNjK/Yuhg5OSQETCRm
	TrzFCGGLSVy4tx4ozsUhJDCdUeLc6/lMEM5fRomvJyczg1SxCWhIHH7/jB3EFhGIkbjQ18wK
	UsQs0M4kcWvWO6j2jYwSl76uZgKp4hQIlni/dDpLFyMHh7BAlMT+vfIgYRYBVYnP6xeDlfAK
	2Er8WXGGGcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIGMkBNQlHv3VhbjBSGLm6pWMECUi
	EvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgsP7
	mfQOxlUNFocYBTgYlXh4JyZxBAixJpYVV+YeYpTgYFYS4f1SBRTiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOa+L91V9IID2xJDU7NbUgtQgmy8TBKdXAuHFC4LnND9xkcgy1X28I+NdlOH3GPsvI
	E0kTj2s67D5/a3Lz3h3nnzTPiQo1Ptveeplj7rdYvUzjHQbTXPjO1c0Ns8mKE8i8Hn6Qx6Xw
	y89Pn14tqYj5w/nAsN5g4tbtLP8Zkmet3BjaxHZSKbjvZ7vIjr1h2r+q+880931xTd7Z8+3S
	ijc7BZVYijMSDbWYi4oTAdwQmVprAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 19 July 2012 20:58, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> > Hi Thomas,
> >
> > I think not good that added the samsung specific code into dw_mmc-
> pltfm.c
> > How about separating to dw-mmc-exynos.c?
> 
> I am not sure of this. The only samsung specific code in
> dw_mmc-pltfm.c file is the data for of_device_id instances. The clock
> lookup added into this file in the 3rd patch does not cause any harm
> on non-samsung SoC's which might not define those clocks (on clock
> lookup failure, there are only warning printed, the driver's probe
> does not fail.
> 
I agree with Thomas' opinion, in addition, the dw_mmc-pltfm.c file can
support that, so adding dw-mmc-exynos.c is not needed now.

> I would prefer not to add separate file for Exynos SoC's for now.
> Splitting into different files will need to defined new callbacks
> which I fell is not really required.
> 
Yes.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

