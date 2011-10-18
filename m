Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1JRGRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:17:34 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18279 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1JRGRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:17:33 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz936eK1432Nzz1202hzz8275bhz32i2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Peter Korsgaard <jacmet@sunsite.dk>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 07:17:52 +0100
Subject: RE: [PATCH] ad525x_dpot: add i2c support for AD5161
Thread-Topic: [PATCH] ad525x_dpot: add i2c support for AD5161
Thread-Index: AcyNBLejNrfhVDtVSSG0TGZAcdUVawAWNFhA
Message-ID: <544AC56F16B56944AEC3BD4E3D59177146E756700D@LIMKCMBX1.ad.analog.com>
References: <1318880376-1310-1-git-send-email-jacmet@sunsite.dk>
In-Reply-To: <1318880376-1310-1-git-send-email-jacmet@sunsite.dk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote on 2011-10-17:
> Commit 6c536e4ce8e (ad525x_dpot: add support for SPI parts) added
> support for the AD5161 through SPI, but the device supports both I2C and
> SPI (depending on the DIS pin), so add it to -i2c as well.
>
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/misc/ad525x_dpot-i2c.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-
> i2c.c index 4ff73c2..a39e055 100644 --- a/drivers/misc/ad525x_dpot-i2c.c
> +++ b/drivers/misc/ad525x_dpot-i2c.c @@ -98,6 +98,7 @@ static const
> struct i2c_device_id ad_dpot_id[] = {
        {"ad5282", AD5282_ID},  {"adn2860", ADN2860_ID},        {"ad5273", AD5273_ID},
 +      {"ad5161", AD5161_ID},  {"ad5171", AD5171_ID},  {"ad5170", AD5170_ID},
        {"ad5172", AD5172_ID},

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


