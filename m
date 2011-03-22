Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1CVVJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:09:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:43750 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab1CVVJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:09:12 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: andy.green@linaro.org, Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
References: <4D79F068.2080009@linaro.org>
	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 08:08:45 +1100
Message-ID: <1300828125.2402.300.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Q(b) If yes, what 'key' is most suitable for identifying the right
> device
>   to attach the data to ?

We already pointed out that in the case of soldered-in device, the
"path" as in the series of -physical- ports leading to the device is
going to be stable.

For anything else, there's no solution. If the device doesn't have a
unique ID, you are toast, period.

On the other hand, I still think platform_data suck big time. Grant made
some good points about the lack of proper typing for example. I believe
that a device-tree based approach is much better in the long run (and
more flexible) despite Andy odd quasi-religious aversion for it.

Cheers,
Ben.

