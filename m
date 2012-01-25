Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2AYBym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:54:42 -0500
Received: from mail2.nsc.com ([12.238.8.132]:36149 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755475Ab2AYByl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:54:41 -0500
X-WSS-ID: 0LYBZZ2-0A-3SN-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 17:54:31 -0800
Subject: RE: [PATCH 6/7] leds-lm3530: replace 'pltfm' with 'pdata'
Thread-Topic: [PATCH 6/7] leds-lm3530: replace 'pltfm' with 'pdata'
Thread-Index: AczaA+5kiunhwer3R6GmjqgWxaXcZwBAD8rA
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3E42@EXMAIL03.scwf.nsc.com>
References: <AczXFgV8f/jdU5qUSd6MQcwmtcr9IA==>
 <B567DBAB974C0544994013492B949F8E3812C6D0D3@EXMAIL03.scwf.nsc.com>
 <CACRpkdYLfNOdRsFpo8u4u_X0obAeuYtvt8bkcyCQ536tw86RyQ@mail.gmail.com>
In-Reply-To: <CACRpkdYLfNOdRsFpo8u4u_X0obAeuYtvt8bkcyCQ536tw86RyQ@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301BF401LS9908693-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch has been sent.

Title : [PATCH v2 2/2] leds-lm3530: replace 'pltfm' with 'pdata'

Thanks & BR
Milo -


-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: Tuesday, January 24, 2012 4:19 AM
To: Kim, Milo
Cc: shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH 6/7] leds-lm3530: replace 'pltfm' with 'pdata'

On Fri, Jan 20, 2012 at 2:51 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Use 'pdata' rather than 'pltfm' in lm3530_init_registers().
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

You're ringht this is a more common naming.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

...but it won't apply because i NACKed the regulator avoidance
patch... so it'll need updating.

Yours,
Linus Walleij

