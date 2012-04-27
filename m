Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab2D0CR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 22:17:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55999 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2D0CR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 22:17:28 -0400
Message-ID: <4F9A01B6.2050502@wwwdotorg.org>
Date: Thu, 26 Apr 2012 20:17:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de
Subject: Re: [PATCH 1/2] pinctrl: support gpio request deferred probing
References: <1335353894-22096-1-git-send-email-b29396@freescale.com> <CACRpkdadLsqpb=X+BmomyRywf=SrgGpbW2B=Myo3zTn_xMHJ2g@mail.gmail.com>
In-Reply-To: <CACRpkdadLsqpb=X+BmomyRywf=SrgGpbW2B=Myo3zTn_xMHJ2g@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 03:36 PM, Linus Walleij wrote:
> On Wed, Apr 25, 2012 at 1:38 PM, Dong Aisheng <b29396@freescale.com> wrote:
> 
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> As pinctrl handles, it may be possible the pinctrl gpio ranges
>> are still not got registered when user call pinctrl_gpio_request.
>> Thus, add defer support for it too.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Since nobody is saying anything and it looks reasonable,
> I just applied this.

I didn't look at this, because V4 was sent without this patch, so I
assumed it'd been dropped by Dong. Was I wrong?
