Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1E3NHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:07:35 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:54131 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1E3NHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:07:34 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: Tejun Heo <htejun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Mon, 30 May 2011 14:07:31 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwbKuYKuEMMBBI3QCqRDVctVjsW1wDn4MGw
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C7777DD92@gretna.indigovision.com>
References: <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
 <20110525094127.GF10146@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C7770967B@gretna.indigovision.com>
 <4DDD823F.5090904@teksavvy.com>
In-Reply-To: <4DDD823F.5090904@teksavvy.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4UD7jv6001286

> > Mark, did you get a chance to clean up the sata_mv spinlock addition in
> > mv_set_main_irq_mask?
>
> Not yet.  I've been waiting to hear back from you as to
> whether they visibly fix anything or not.

Having now tested with Tejun's two patches and without the spinlock in
mv_set_main_irq_mask for a reasonable time, the hotplug seems to be very
reliable.  So I think it's probably best to leave the spinlock out and
continue to observe the behaviour with further testing.

Thanks,
Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
