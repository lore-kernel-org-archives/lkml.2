Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1DRKam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:30:42 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:46181 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1DRKae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:30:34 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Justin Maggard <jmaggard10@gmail.com>, Tejun Heo <htejun@gmail.com>
Date: Mon, 18 Apr 2011 11:30:28 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv7gur0RT9uqwC6Qx+WMGhG/eIw0gCLmWFQ
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C772DA764@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA5BCF3.5080205@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772DA491@gretna.indigovision.com>
 <4DA79134.1010508@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772DA5DD@gretna.indigovision.com>
 <4DA86606.308@teksavvy.com>
In-Reply-To: <4DA86606.308@teksavvy.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3IAV78w006556

> > libata.force=1.5g
>
> Mmm... I suppose it could be getting stuck at 1.5g,
> and not transitioning back to "auto detect" or something.
>
> That part of sata_mv involves a bit of voo-doo,
> because I was reluctant to cut/paste the 200 lines or so
> of generic code just for the sake of changing five lines.
>
> Perhaps the generic code has changed since this was originally working,
> and now no longer always works for sata_mv..
>
> I suppose you have a good reason for using "libata.force=1.5g" there?

Hi Mark,

I hope you had a good weekend.

The SATA speed was limited because there were concerns over signal integrity at
3Gbps early on in our product development, and even at 1.5Gbps the SATA links
are not a bottleneck in our platform.  The signal integrity issues have been
addressed, and we would like to remove the limit, but this obviously has an
additional test overhead and it is low down on our priorities.

Out of interest I examined the behaviour of the hotplug with the 1.5Gbps limit
removed, but I saw no change in the port lockup behaviour.


Cheers,

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
