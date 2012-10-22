Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2JVAXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:23:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39149 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2JVAXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:23:52 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] lp8788-charger: fix ADC channel names
Thread-Topic: [PATCH 2/3] lp8788-charger: fix ADC channel names
Thread-Index: Ac2s93JcsmYrNrJMT1e2Ylkwid0fcgA1alyAAIducxA=
Date: Mon, 22 Oct 2012 00:23:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417930F@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F64178F9F@DQHE02.ent.ti.com>
 <50817497.5070900@kernel.org>
In-Reply-To: <50817497.5070900@kernel.org>
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

> >  LP8788 IIO ADC driver and platform data have specific naming
> convention
> >  for ADC channels. That is using prefix 'lp8788_'.
> >  To keep this rule, ADC channel names are changed.
> >
> It's a little unusual to name the consumer side of the map so
> specifically.
> If you want to do so it's up to you though (and it obviously has to
> match)
> that provided in platform_data including the default map in the iio
> driver.

Thanks a lot for your review.
You're right. A channel name is configurable data in the platform side,
so the fixed patch has been sent as below.

[PATCH v2 2/3] lp8788-charger: fix ADC channel names

Best Regards,
Milo
