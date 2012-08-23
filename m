Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2HWCNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:13:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:48472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2HWCNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:13:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,297,1344236400"; 
   d="scan'208";a="183970922"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] power_supply: Add new power supply VALID property
Thread-Topic: [PATCH] power_supply: Add new power supply VALID property
Thread-Index: AQHNgNNXLK7g3wcSsUiuUMSTS2XyJpdmp3BQ
Date: Thu, 23 Aug 2012 02:13:40 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD23C04A@BGSMSX102.gar.corp.intel.com>
References: <1343532714-28040-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120823015828.GB24471@lizard>
In-Reply-To: <20120823015828.GB24471@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7N2DrIB027919

> On Sun, Jul 29, 2012 at 09:01:54AM +0530, Ramakrishna Pallala wrote:
> > It is possible that users can use non-standard chargers or use invalid
> > batteries especially with mobile devices.
> 
> Maybe 'original' or 'authentic' would be a better term for this?
> For me, 'valid' is kind of too broad and confusing. :-/
> 
> [...]
> > +VALID - indicates the power supply connected is valid(1) or
> > +invalid(0)
> > +
> 
> But if you still think that 'valid' is a better term, can you please document it in
> more detail?

Authentic looks fine too. I will resubmit the patch with more details.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
