Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2HTPdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:33:40 -0400
Received: from antcom.de ([188.40.178.216]:40784 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2HTPdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:33:37 -0400
Message-ID: <503258CE.9030106@antcom.de>
Date: Mon, 20 Aug 2012 17:33:34 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND v4] spi/pl022: add devicetree support
References: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com> <50324835.6030806@gmail.com>
In-Reply-To: <50324835.6030806@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 04:22 PM, Rob Herring wrote:
>>  .../devicetree/bindings/spi/spi_pl022.txt          |   15 +++
>>  drivers/spi/spi-pl022.c                            |  114 ++++++++++++++++----
>>  2 files changed, 110 insertions(+), 19 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/spi/spi_pl022.txt b/Documentation/devicetree/bindings/spi/spi_pl022.txt
>> index 306ec3f..b089ec7 100644
>> --- a/Documentation/devicetree/bindings/spi/spi_pl022.txt
>> +++ b/Documentation/devicetree/bindings/spi/spi_pl022.txt
>> @@ -6,7 +6,22 @@ Required properties:
>>  - interrupts : Should contain SPI controller interrupt
>>  
>>  Optional properties:
>> +- pl022,num-chipselects : total number of chipselects
> 
> We have this for other spi controllers too. Define a generic property.

Currently, we have:

num-cs
ti,spi-num-cs
fsl,spi-num-chipselects
fsl,espi-num-chipselects
(pl022,num-chipselects)

Would "num-cs" be the right one to use?

Thanks,

Roland
