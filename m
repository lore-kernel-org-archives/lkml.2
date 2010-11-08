Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0KHLI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:08:57 -0500
Received: from smtp.nokia.com ([192.100.105.134]:39275 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KHLI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:08:56 -0500
From: <ilkka.koskinen@nokia.com>
To: <alan@lxorguk.ukuu.org.uk>
CC: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Date: Mon, 8 Nov 2010 12:08:07 +0100
Subject: RE: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Topic: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Index: Act+1xqBGuQ+GlutQZqhySX6uKWMVAAXTwLg
Message-ID: <F80267346F10C541946CBE8909F1C39E36817A8845@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
 <20101107235157.728ea5b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20101107235157.728ea5b6@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Nov 2010 11:08:10.0518 (UTC) FILETIME=[3AB5D360:01CB7F35]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From: ext Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: 08 November, 2010 01:52
>
>> +	datalen = p->custom_len * sizeof(p->custom_data[0]);
>
>signed
>
>> +	if (datalen > MAX_EFFECT_SIZE) {
>
>unsigned

It should be unsigned. I'll fix it.

>> +	memcpy(einfo->buf, p->custom_data, datalen);
>
>ungood

Yep, that's clearly wrong too. Should be copy_from_user() I suppose.

Thanks, Ilkka

