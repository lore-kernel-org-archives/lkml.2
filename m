Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab2EPN4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:56:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:56266 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2EPN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:56:07 -0400
Message-ID: <4FB3B1F3.6080102@atmel.com>
Date: Wed, 16 May 2012 15:56:03 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging
 tree
References: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au> <201205161054.15610.arnd@arndb.de>
In-Reply-To: <201205161054.15610.arnd@arndb.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 12:54 PM, Arnd Bergmann :
> On Wednesday 16 May 2012, Stephen Rothwell wrote:
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/boot/dts/at91sam9g20.dtsi between commit 7cb2e629a240 ("ARM:
>> AT91: Add ADC driver to the at91sam9g20 dtsi") from the staging tree and
>> commit 5b6089cb6f28 ("ARM: at91: add at91sam9260 DT support") from the
>> arm-soc tree.
>>
>> So, I didn't know what to do with this, so I used the arm-soc version of
>> this file (effectively throwing away the staging tree change).  Hints,
>> anyone?
> 
> I suspect the addition of the adc node should just go into the
> at91sam9260.dtsi file.

Well, not so sure...

Hi all,

I am on the subject till this morning to figure out if the parameters
are SoC dependent. It seems that the ADC is the same between those two
platforms but the technology is different: I have to figure out the
details internally.

I will give you a patch on top of arm-soc soon. It will replace the one
in staging-next: does it sound good to you?

Bye,
-- 
Nicolas Ferre
