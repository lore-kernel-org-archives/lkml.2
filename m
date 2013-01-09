Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3AICnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:43:42 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38301 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306Ab3AICnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:43:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>, Lubomir Rintel <lkundrak@v3.sk>
CC: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 8 Jan 2013 18:43:23 -0800
Subject: RE: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in
 alternate place
Thread-Topic: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in
 alternate place
Thread-Index: Ac3uER2MPuMcRpH8SLW8UXMVcs+KAgAAICjw
Message-ID: <477F20668A386D41ADCC57781B1F70430D13FDB783@SC-VEXCH1.marvell.com>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
	 <1357689361-7969-2-git-send-email-lkundrak@v3.sk>
 <1357698538.1806.43.camel@aeonflux>
In-Reply-To: <1357698538.1806.43.camel@aeonflux>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r092hjsc004093


> > linux-firmware ships the sd8688* firmware images that are shared with
> > libertas_sdio WiFi driver under libertas/. libertas_sdio looks in both places
> > and so should we.
> >
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > ---
> >  drivers/bluetooth/btmrvl_sdio.c |   24 ++++++++++++++++++++++--
> >  drivers/bluetooth/btmrvl_sdio.h |    6 ++++--
> >  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> NAK from me on this one. I do not want the driver to check two
> locations. That is what userspace can work around.
> 
> If we want to unify the location between the WiFi driver and the
> Bluetooth driver, I am fine with that, but seriously, just pick one over
> the other. I do not care which one.

The unified location is mrvl/ directory.

We can probably move SD8688 firmware & helper binaries to mrvl/ and have both drivers grab the images there?

Regards,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
