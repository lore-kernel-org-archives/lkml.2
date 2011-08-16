Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1HPIA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 04:00:59 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:11838
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab1HPIA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 04:00:57 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzz8275bhz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: "wim@iguana.be" <wim@iguana.be>
CC: Dajun <dajun.chen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 07/11] Watchdog: DA9052 watchdog support
Thread-Topic: [PATCH v2 07/11] Watchdog: DA9052 watchdog support
Thread-Index: Acxb6plxuNRLKfByQiaxcDYMxiQlwQ==
Date: Tue, 16 Aug 2011 08:00:52 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CEDCFE6@KCHJEXMB02.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [113.193.146.79]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7G81ONO028120

On Fri, 2011-08-05 at 19:22 +0530, ashishj3 wrote:
> This driver adds support for the watchdog functionality provided by the Dialog
> Semiconductor DA9052 PMIC chip.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since V2:
> - Code restructured for simplicty.
> - Add watchdog documentation.
> - Remove Auto strobing feature.
> - Remove strobe filtering flag.
> --- 
Any comment for this patch?


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
