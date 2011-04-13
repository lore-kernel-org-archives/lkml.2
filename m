Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1DMQVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:21:41 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:27113 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab1DMQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:14 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Wed, 13 Apr 2011 17:13:07 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv57PeUZmOXzJy/SmuqNZkglMtp7AAB8a1A
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C772DA253@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA5BCF3.5080205@teksavvy.com>
In-Reply-To: <4DA5BCF3.5080205@teksavvy.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3DGLsZj014093

> Yeah, I'm suspecting there's a loophole in the logic there somewhere.
>
> I dusted off the 6041 reference card I have here, and played with the cables for a while.  Managed to > get one port to stop responding to hot plug fairly quickly, though I'm not sure how/why.
>
> Then I added a debug printk() to mv_write_main_irq_mask(), with no other changes, and that appears to > have been enough to change the race timing so that I could no longer produce the problem.
>
> Bruce, here's a slightly-ugly patch that should remove all doubt about races in the irq_mask.  Please > apply it, test with it, and let me know here if the issue goes away.
>
> Thanks

Thanks Mark. I was about to try out some tracing in writelfl because I
suspected the irq mask was getting clobbered somewhere along the way, but
I'd been distracted by other work.  I shall try your patch out as soon as
I can, and report back.

Cheers,

Bruce.


Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/index.php/en/news.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
