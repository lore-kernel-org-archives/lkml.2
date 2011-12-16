Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab1LPIPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:15:12 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:35775
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416Ab1LPIPJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:15:09 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>
Subject: RE: linux-next: build failure after merge of the regmap tree
Thread-Topic: linux-next: build failure after merge of the regmap tree
Thread-Index: AQHMu8pJcS+h6HxWskeAYdU7g1Upj5XeHYhQ
Date: Fri, 16 Dec 2011 08:15:05 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9D1AD3@KCHJEXMB01.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1F9D0895@KCHJEXMB01.kpit.com>
 <1323941146.32031.49.camel@dhruva>
 <CACxGe6tfxGToC2ScUdQv7KNu2xdhxA4ZG=Ms=oZZCQ+2A-aiTQ@mail.gmail.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9D1AB5@KCHJEXMB01.kpit.com>
 <CACxGe6tmqXWZJThk4m31=HzWMZPMMgO4f8h9H=xc_0thjWOJ8Q@mail.gmail.com>
In-Reply-To: <CACxGe6tmqXWZJThk4m31=HzWMZPMMgO4f8h9H=xc_0thjWOJ8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
Sent: Friday, December 16, 2011 1:41 PM
To: Ashish Jangam
Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Mark Brown; Dajun
Subject: Re: linux-next: build failure after merge of the regmap tree

On Fri, Dec 16, 2011 at 12:19 AM, Ashish Jangam
<Ashish.Jangam@kpitcummins.com> wrote:
>
>
> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Thursday, December 15, 2011 11:55 PM
> To: Ashish Jangam
> Cc: Stephen Rothwell; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Mark Brown; Dajun
> Subject: Re: linux-next: build failure after merge of the regmap tree
>
> On Thu, Dec 15, 2011 at 2:25 AM, Ashish Jangam
> <ashish.jangam@kpitcummins.com> wrote:
>> Fixes DA9052 GPIO errors.
>>
>> This patch is functionally tested on Samsung SMDKV6410.
>>
>> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
>> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
>> ---
>>  drivers/gpio/gpio-da9052.c      |   37 ++++--------------------------
>>  include/linux/mfd/da9052/gpio.h |   48 +++++++++++++++++++++++++++++++++++++++
>
> gpio-da9052.c is the only users of mfd/da9052/gpio.h.  Why is this
> include file needed?  The #defines can simply stay in the .c file.
> I've picked up the patch, but modified it to keep the header defines
> in the .c file.  If there is a reason this won't work, then please let
> me know.
>
> This header file is shared between GPIO and LED module. I have already
> posted this LED long back got ACK but did not got merged due to its
> dependency on MFD module.

Are the LEDs attached to GPIOs?  If so, then is there a reason that
the leds-gpio driver can't be used?

Oh yes we can use leds-gpio driver.

g.


