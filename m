Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2DYIxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:53:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19854 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2DYIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:53:07 -0400
X-AuditID: cbfee60e-b7b3bae000007458-f6-4f97bb723631
Date: Wed, 25 Apr 2012 08:53:06 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [patch] Extcon: check for allocation failure
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120425085144848@myungjoo.ham
Msgkey: 20120425085144848@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120425085144848@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29718349.140341335343984348.JavaMail.weblogic@epml25>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3P8rLKb005080

> Return -ENOMEM if the kmalloc() fails.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


> 
> diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
> index 3bc4b8a..fe5a038 100644
> --- a/drivers/extcon/extcon_class.c
> +++ b/drivers/extcon/extcon_class.c
> @@ -621,6 +621,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
>  	}
>  
>  	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> +	if (!edev->dev)
> +		return -ENOMEM;
>  	edev->dev->parent = dev;
>  	edev->dev->class = extcon_class;
>  	edev->dev->release = extcon_dev_release;
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
