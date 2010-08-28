Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0H1PST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:18:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58949 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0H1PSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SPkNJz5k6xLU1RStj6TiMaSn9iOex1JIXf535Wkd3KXjiVvJ+sCzyIcvvtxd2V6izn
         K89l4HaqnuMywIo5qdIkGCfrFnmyrx6twMdlNLbav7HKlWwlRTaTPNHLRz3Al1KIACtN
         n5i+2ITK/kmpstF382TpW5Mmg2su0PPujf/xQ=
MIME-Version: 1.0
In-Reply-To: <20100823174852.GB26928@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
	<20100823125704.GU27749@pengutronix.de>
	<20100823174852.GB26928@pengutronix.de>
Date: Sat, 28 Aug 2010 17:18:17 +0200
Message-ID: <AANLkTimmEKfErV17RWNBO-pVCfFtFw=yJL2v92UBN0=2@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

>> +     evt = readl(SDMA_H_EVTOVR);
>> +     mcu = readl(SDMA_H_HOSTOVR);
>> +     dsp = readl(SDMA_H_DSPOVR);
> __raw_readl?

Sorry I never understood this __raw_[read|write][b|w|l] vs.
plain read[b|w|l] proliferation in some drivers and code.

What's the reason for?

Yours,
Linus Walleij
