Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1K1GB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:01:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:45115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1K1GB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:01:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80526226"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        =?utf-8?B?77+92rDvv73vv73vv70=?= <kyungmin.park@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Date: Mon, 28 Nov 2011 11:31:11 +0530
Subject: RE: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
Thread-Topic: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042
 fuel gauge
Thread-Index: Acyr0JFrFTSmOQQvQRy84VT7+/w8mABwcnvQ
Message-ID: <12D0C12AF19E15409D57F22566E88EF50A882C108F@bgsmsx501.gar.corp.intel.com>
References: <18021216.478661315185875229.JavaMail.weblogic@epml15>
 <12D0C12AF19E15409D57F22566E88EF50975BF4F98@bgsmsx501.gar.corp.intel.com>
 <20111126001545.GA24278@oksana.dev.rtsoft.ru>
In-Reply-To: <20111126001545.GA24278@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAS61c6c030324



> -----Original Message-----
> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Saturday, November 26, 2011 5:46 AM
> To: Pallala, Ramakrishna
> Cc: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org; dwmw2@infradead.org; ï¿½Ú°ï¿½ï¿½ï¿½;
> Wolfram Sang; R, Durgadoss
> Subject: Re: [PATCHv1 1/1] [Power Supply]: Fix error handling in max17042 fuel gauge
> 
> On Wed, Sep 07, 2011 at 02:00:29PM +0530, Pallala, Ramakrishna wrote:
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
> 
> Merged, much thanks!
> 
> Note that I had to manually fix conflicts with
> 
> 	commit cf7a8c03db792894f436db5f3ffc44d947b9b068
> 	Author: MyungJoo Ham <myungjoo.ham@samsung.com>
> 	Date:   Wed Aug 17 10:18:34 2011 +0900
> 
> 	    max17042_battery: Bugfix of incorrect voltage register value interpretation
> 
> 
> So, the resulting patch in battery-2.6.git tree as follows, please
> check if everything is OK:

The patch looks good.
Thanks for resolving the conflicts :)

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
