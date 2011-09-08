Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1IHXUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:20:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:19885 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1IHXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:20:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,351,1312182000"; 
   d="scan'208";a="46859540"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Date: Thu, 8 Sep 2011 23:07:03 +0530
Subject: RE: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in
 max17042 fuel gauge
Thread-Topic: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in
 max17042 fuel gauge
Thread-Index: AcxtOsRnz/g5r7rjSFiRud9kKwPRzgBEs2mQ
Message-ID: <12D0C12AF19E15409D57F22566E88EF50975BF58AE@bgsmsx501.gar.corp.intel.com>
References: <14735031.596001315385240106.JavaMail.weblogic@epml15>
In-Reply-To: <14735031.596001315385240106.JavaMail.weblogic@epml15>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p88NKLYn027777

Hi Anton,

> -----Original Message-----
> From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> Sent: Wednesday, September 07, 2011 2:17 PM
> To: Pallala, Ramakrishna; linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; dwmw2@infradead.org; ¹Ú°æ¹Î; Wolfram Sang; R, Durgadoss
> Subject: Re: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
> 
> Sender : Pallala, Ramakrishna<ramakrishna.pallala@intel.com> Date : 2011-09-07 17:30
> (GMT+09:00)
> > Hi MyungJoo,
> >
> > > -----Original Message-----
> > > From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> > > Sent: Monday, September 05, 2011 6:55 AM
> > > To: Pallala, Ramakrishna; linux-kernel@vger.kernel.org
> > > Cc: Anton Vorontsov; dwmw2@infradead.org; ¹Ú°æ¹Î; Wolfram Sang; R, Durgadoss
> > > Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
> > >
> > > Sender : Ramakrishna Pallala<ramakrishna.pallala@intel.com> Date : 2011-09-02 15:45
> > > (GMT+09:00)
> > > >
> > > > In max17042_get_property(...), the values returned by
> > > > max17042_read_reg are directly assigned to the variables,
> > > > even if the read results in an error.
> > > >
> > > > This patch checks for the return code from max17042_read_reg and
> > > > exits the function if there is any error.
> > > >
> > > > Signed-off-by: Ramakrishna Pallala
> > > > ---
> > > > drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
> > > > 1 files changed, 58 insertions(+), 27 deletions(-)
> > > >
> > >
> > > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >
> > Thanks for the Ack.
> > When can I expect the patch to be merged ?
> >
> > Thanks,
> > Ram
> >
> 
> Hello Ram,
> 
> Although I'd be so glad to be able to merge patches of MAX17042 (and
> MAX8997/8998/8952/8903/...?) by myself; however, I'm not a maintainer of MAX17042.
> 
> I guess you need to wait for Anton.
> 
> Cheers,
> MyungJoo

When can I expect the patch to be merged ?

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
