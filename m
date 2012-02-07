Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2BGFUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:20:40 -0500
Received: from mail2.nsc.com ([12.238.8.132]:38334 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751808Ab2BGFUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:20:39 -0500
X-WSS-ID: 0LZ0C6B-0A-1N5-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Feb 2012 21:20:31 -0800
Subject: RE: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
 dev_attr
Thread-Topic: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
 dev_attr
Thread-Index: AczgVaUQ3hF/QGbiQW2WPkyktVduZwFAcx+Q
Message-ID: <B567DBAB974C0544994013492B949F8E3812ED44AE@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812DEC933@EXMAIL03.scwf.nsc.com>
 <20120131121930.4cb1a05a.akpm@linux-foundation.org>
In-Reply-To: <20120131121930.4cb1a05a.akpm@linux-foundation.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632E6B281LS10196260-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, February 01, 2012 5:20 AM
> To: Kim, Milo
> Cc: Linus Walleij; shreshthakumar.sahu@stericsson.com;
> rpurdie@rpsys.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
> dev_attr
> 
> On Mon, 30 Jan 2012 23:33:44 -0800
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
> 
> > To get information about brightness control mode, lm3530_mode_get()
> is added.
> 
> drivers/leds/leds-lm3530.c already has an implementation of
> lm3530_mode_get().  I assume these patches were prepared against some
> old kernel.  Please don't do that!
> 

Thank you for your advice.
Revised patches were sent - based on kernel 3.2.4.

[PATCH v4 1/5] leds-lm3530: set the max_brightness to 127
[PATCH v4 2/5] leds-lm3530: replace i2c_client with led_classdev
[PATCH v4 3/5] leds-lm3530: support pwm input mode
[PATCH v4 4/5] leds-lm3530: remove LM3530_ALS_ZONE_REG code
[PATCH v4 5/5] leds-lm3530: replace pltfm with pdata

Best Regards,
Milo -




