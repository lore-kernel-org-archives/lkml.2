Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1CNPAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:00:07 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:43395 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1CNPAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:00:05 -0400
X-AuditID: 83cfa826-b7c18ae00000543e-58-4d7e2d711402
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>, <matti.j.aaltonen@nokia.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hthebaud@insidefr.com>
Date: Mon, 14 Mar 2011 16:59:53 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvfPyS7ttnLRyGCRXa8QB+sRnxvzQC+XASw
Message-ID: <99B09243E1A5DA4898CDD8B7001114481082FAE10A@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103101452.54862.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B7001114481082EF2A65@EXMB04.eu.tieto.com>
 <201103101720.53782.arnd@arndb.de>
In-Reply-To: <201103101720.53782.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>Oh, I see you simply do
>
>       ret = i2c_master_send(client, info->buf, len);
>       usleep_range(1000, 10000);
>
>and assume that the buffer can always be written within a 
>milisecond, so you just slow down output enough to never have 
>to worry about it, right?
>
>A nicer solution would be to have an interrupt driven output 
>so you know when the i2c buffers have been flushed.

Well, I get the idea of interrupt driven output, but as I have little linux kernel experience I'm not sure how to implement this. 
Can you extend you thoughts or if you know piont me a driver which uses that concept?

I'm not sure who should rise an interrupt when data has been flushed. I2c core or the chip itself?
What's more, I guess the i2c_master_send  is a synchronous call and when it returnes we know it flushed data. Right? 

/Waldek

