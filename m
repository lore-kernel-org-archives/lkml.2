Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2EIGsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:48:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:8977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab2EIGsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:48:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97976797"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "Tc, Jenny" <jenny.tc@intel.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        ??? <cw00.choi@samsung.com>
Subject: RE: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Topic: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Index: AQHNLK2y4rIr96V0H02bTcfMJWXYepbAFasQgACMPICAAGNxoA==
Date: Wed, 9 May 2012 06:47:54 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD142B57@BGSMSX102.gar.corp.intel.com>
References: <3331130.84351336435272215.JavaMail.weblogic@epml16>
 <D854C92F57B1B347B57E531E78D05EAD1426B2@BGSMSX102.gar.corp.intel.com>
 <20ADAB092842284E95860F279283C56421CF0A@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <20ADAB092842284E95860F279283C56421CF0A@BGSMSX101.gar.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q496mELO000763

> >
> > As part of charge enablement we generally program charge current,
> > charge voltage into the charger chip.
> >
> > We can pass the charging parameters CC and CV in two ways.
> > 1. Add these params in charger_desc struct and the  charger regulator
> > can get these params using container_of() call? but becomes complex.
> >
> > 2. use regulator_set_voltage()/regulator_set_current_limit() functions
> > to set the CV and CC params.
> > but not suitable as is, we have add support in regulator framework
> >
> 
> regulator_ops has support for set_current_limit and set_voltage. Can we use the same for
> setting CC and CV?

I feel set_voltage()/set_current_limit() is more suitable to control input source current and
voltage, but CC and CV are more like output parameters from charger.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
