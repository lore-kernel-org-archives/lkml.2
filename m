Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2CHCWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:22:24 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:8031
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab2CHCWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:22:21 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zz1454I1432N4015Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h93fhbe9k)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: RE: [PATCH 02/03] HWMON: HWMON driver for DA9052/53 PMIC v3
Thread-Topic: [PATCH 02/03] HWMON: HWMON driver for DA9052/53 PMIC v3
Thread-Index: AQHM/JXmEJU6Lx/WkUKbHGH3BR/mPZZfqZSw
Date: Thu, 8 Mar 2012 02:21:34 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED2B9A6FE5@KCHJEXMB02.kpit.com>
References: <1330698545.21817.31.camel@dhruva>
 <1331147302.23014.370.camel@groeck-laptop>
In-Reply-To: <1331147302.23014.370.camel@groeck-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [113.193.129.58]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q282MTUk020005

> Only comment I would have is that it might make sense to use
> DIV_ROUND_CLOSEST(). That is a minor issue, though, so feel free to add
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Question is where this is going. I can not add it to hwmon-next without
> the matching mfd changes. Any idea ?
This patch will depends on DA9052 MFD which is already merged in main line. However this
also depends on a incremental patch for MFD which is yet to get ACK but soon should be in. 
> 
> Thanks,
> Guenter
> 
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
