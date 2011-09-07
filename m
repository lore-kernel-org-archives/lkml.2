Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1IGRE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:04:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61390 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1IGREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:04:21 -0400
X-AuditID: cbfee611-b7c50ae0000047db-b9-4e672e132ee9
Date: Wed, 07 Sep 2011 08:47:20 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110907083858341@myungjoo.ham
Msgkey: 20110907083858341@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110907083858341@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14735031.596001315385240106.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87H54g4021319

Sender : Pallala, Ramakrishna<ramakrishna.pallala@intel.com> Date : 2011-09-07 17:30 (GMT+09:00)
> Hi MyungJoo,
> 
> > -----Original Message-----
> > From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> > Sent: Monday, September 05, 2011 6:55 AM
> > To: Pallala, Ramakrishna; linux-kernel@vger.kernel.org
> > Cc: Anton Vorontsov; dwmw2@infradead.org; ¹Ú°æ¹Î; Wolfram Sang; R, Durgadoss
> > Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
> > 
> > Sender : Ramakrishna Pallala<ramakrishna.pallala@intel.com> Date : 2011-09-02 15:45
> > (GMT+09:00)
> > >
> > > In max17042_get_property(...), the values returned by
> > > max17042_read_reg are directly assigned to the variables,
> > > even if the read results in an error.
> > >
> > > This patch checks for the return code from max17042_read_reg and
> > > exits the function if there is any error.
> > >
> > > Signed-off-by: Ramakrishna Pallala
> > > ---
> > > drivers/power/max17042_battery.c |   85 ++++++++++++++++++++++++++------------
> > > 1 files changed, 58 insertions(+), 27 deletions(-)
> > >
> > 
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 
> Thanks for the Ack.
> When can I expect the patch to be merged ?
> 
> Thanks,
> Ram
> 

Hello Ram,

Although I'd be so glad to be able to merge patches of MAX17042 (and MAX8997/8998/8952/8903/...?) by myself; however, I'm not a maintainer of MAX17042.

I guess you need to wait for Anton.

Cheers,
MyungJoo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
