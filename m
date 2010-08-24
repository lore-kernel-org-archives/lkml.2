Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0HXPBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:01:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59047 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab0HXPBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hyIxM6bDea2p/NiTj3wHQMQlHVuM1niZW1bwgPuAXbX3gYsresmf7MaZtTvZZ04Rsh
         QIVFoizOasPwirNhR4bMDMiwxT4NDBiI+Hu03rz5a406fnseT54sppYzEemur/4OsjBz
         +v1mRSsissxNykT9exGyZO4Zf8m0M222o6QvY=
MIME-Version: 1.0
In-Reply-To: <19571.31677.407213.580581@ipc1.ka-ro>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
	<20100823125704.GU27749@pengutronix.de>
	<19571.31677.407213.580581@ipc1.ka-ro>
Date: Tue, 24 Aug 2010 17:01:43 +0200
Message-ID: <AANLkTik9sYW9My1SDUV0zvNZaR+UME9z5Z1EMep98Dy-@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/24 Lothar Waﬂmann <LW@karo-electronics.de>:
> [Sacha]
> [...]
>> +static int __devinit sdma_probe(struct platform_device *pdev)
>>
> __devinit/__devexit is for hot-pluggable devices. I don't think the
> SDMA controller is hot-pluggable, so __init/__exit could be used here.

Then the .probe member has to be removed from the
struct platform_driver and platform_driver_probe() used instead
of platform_driver_register().

But it'd work fine I think.

Yours,
Linus Walleij
