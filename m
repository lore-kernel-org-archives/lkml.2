Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842Ab2FDPsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:48:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34578 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2FDPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:48:45 -0400
Message-ID: <4FCCD8D9.2070005@atmel.com>
Date: Mon, 4 Jun 2012 17:48:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91: platform data for atmel-mci (for 3.5)
References: <4FBE4FE7.3010005@atmel.com> <4FC722B7.10409@atmel.com> <CAOesGMhq8uzei+Dn8=1iYrTiAOtuByjm58j9zgFyORVG5VZuNQ@mail.gmail.com>
In-Reply-To: <CAOesGMhq8uzei+Dn8=1iYrTiAOtuByjm58j9zgFyORVG5VZuNQ@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 11:04 PM, Olof Johansson :
> Hi Nicolas,
> 
> On Thu, May 31, 2012 at 12:50 AM, Nicolas Ferre <nicolas.ferre@atmel.com
> <mailto:nicolas.ferre@atmel.com>> wrote:
> 
>     On 05/24/2012 05:12 PM, Nicolas Ferre :
>     > Hi Arnd, hi Olof,
> 
>     Ping?
> 
>     (or maybe you will have a look at this after the merge window...)
> 
> 
> So, I looked at this branch yesterday but I wasn't entirely happy with
> the number of ifdefs it adds.

Unfortunately, this is the usual shape of any devices/boards files on
AT91. This amount will be reduced when we remove the old driver and when
we move newer/popular devices to Device Tree...

> If the idea is to deprecate the old driver, wouldn't it make more sense
> to just cut everyone over instead of having both sets of setup in the
> kernel?

Well, the old driver has existed since a very long time and I think that
people are used to it on oldest platforms. This is why we put in place a
overlapping period. This way we hope that the transition will be smoother.
On the other hand, the old code will be removed in 3.7 so the
overlapping period will not be so long.
I hope that it will allow people to track bugs if some are remaining and
switch to newer driver easily.

Best regards,
-- 
Nicolas Ferre
