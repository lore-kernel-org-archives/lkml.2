Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1DHMng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:43:36 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:34639 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab1DHMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:43:34 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Fri, 8 Apr 2011 13:43:29 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv0nIBOlbfW+McfTiyZIOqiSmFGbwBTJuqA
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
In-Reply-To: <4D9CD275.9000002@teksavvy.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p38Chi9d013433

Hi Mark,

> On 11-04-06 10:57 AM, Bruce Stenning wrote:
> > [...]
> >
> > The following changeset was seen as a strong candidate for addressing
> > this problem:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=933cb8e5fcdebd4b666165e3f039f814d62b0e52
>
> That changeset is already in upstream kernels (kernel.org).
> Does the latest kernel (2.6.38) w/ sata_mv work ?

The 2.6.38.2 kernel still exhibits the same lockups that we see with the
2.6.26 kernel.

Alejandro Riveira FernÃ¡ndez kindly forwarded my email to the linux-ide list,
so I shall take the discussion there and away from the main kernel list.


Kind Regards,

Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/news2011.php
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
