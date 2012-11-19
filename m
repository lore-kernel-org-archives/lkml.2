Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2KSGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:25:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:56081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2KSGZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:25:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,276,1352102400"; 
   d="scan'208";a="249253409"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tc, Jenny" <jenny.tc@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: RE: [PATCH 2/2] power_supply: Register power supply for thermal
 cooling device
Thread-Topic: [PATCH 2/2] power_supply: Register power supply for thermal
 cooling device
Thread-Index: AQHNxUaY2ZyhOboc606oAryrHIRa/JfwspvA
Date: Mon, 19 Nov 2012 06:25:50 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD24557425@BGSMSX102.gar.corp.intel.com>
References: <1349801759-19647-1-git-send-email-ramakrishna.pallala@intel.com>
 <20121118043533.GB18226@lizard.sbx05977.paloaca.wayport.net>
In-Reply-To: <20121118043533.GB18226@lizard.sbx05977.paloaca.wayport.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAJ6Q1Cd013596

> > +static int ps_get_cur_chrage_cntl_limit(struct thermal_cooling_device
> > +*tcd,
> 
> Typo, "charge".
> 
> > +						unsigned long *state)
> > +{
> > +	struct power_supply *psy;
> > +	union power_supply_propval val;
> > +	int ret;
> > +
> > +	WARN_ON(tcd == NULL);
> 
> This is unneeded, we'll get oops anyway.
> 
> I fixed it up and applied, thank you!

Gr8 Thanks!

/Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
