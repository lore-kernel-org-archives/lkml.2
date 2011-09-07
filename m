Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1IGRDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:03:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:14777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab1IGQ7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45975723"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Date: Wed, 7 Sep 2011 14:00:29 +0530
Subject: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
Thread-Topic: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
Thread-Index: AcxrapbRfrSfCsf3TGGOCBkhDXnD3ABzTGLw
Message-ID: <12D0C12AF19E15409D57F22566E88EF50975BF4F98@bgsmsx501.gar.corp.intel.com>
References: <18021216.478661315185875229.JavaMail.weblogic@epml15>
In-Reply-To: <18021216.478661315185875229.JavaMail.weblogic@epml15>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87H4xWU021300

Hi MyungJoo,

> -----Original Message-----
> From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> Sent: Monday, September 05, 2011 6:55 AM
> To: Pallala, Ramakrishna; linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; dwmw2@infradead.org; ¹Ú°æ¹Î; Wolfram Sang; R, Durgadoss
> Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
> 
> Sender : Ramakrishna Pallala<ramakrishna.pallala@intel.com> Date : 2011-09-02 15:45
> (GMT+09:00)
> >
> > In max17042_get_property(...), the values returned by
> > max17042_read_reg are directly assigned to the variables,
> > even if the read results in an error.
> >
> > This patch checks for the return code from max17042_read_reg and
> > exits the function if there is any error.
> >
> > Signed-off-by: Ramakrishna Pallala
> > ---
> > drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
> > 1 files changed, 58 insertions(+), 27 deletions(-)
> >
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Thanks for the Ack.
When can I expect the patch to be merged ?

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
