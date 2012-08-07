Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2HGIKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:10:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38329 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2HGIKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:10:08 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>, Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
Thread-Topic: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
Thread-Index: AQHNb+LfXR8JfzaAFkiwBVrdjvH+C5dNHOaAgADpvtA=
Date: Tue, 7 Aug 2012 08:09:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FEBDE@DQHE02.ent.ti.com>
References: <1343824834.3859.2.camel@phoenix>
 <CAK5ve-+dvpQqj1q9QF8nfST0Ff=W7WCO=_jYdGi7gOjsWO+93w@mail.gmail.com>
In-Reply-To: <CAK5ve-+dvpQqj1q9QF8nfST0Ff=W7WCO=_jYdGi7gOjsWO+93w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We need to do left shift (cfg->num + LP8788_ISINK_SCALE_OFFSET) bits
> for
> > updating scale configuration.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> 
> Milo, I think this patch from Axel is reasonable. could you please
> take a look at this?
> 
> -Bryan

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Thanks,
Milo -
