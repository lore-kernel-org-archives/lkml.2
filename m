Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2IUGAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:00:39 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:47965 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab2IUGAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:00:17 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Robert Morell <rmorell@nvidia.com>,
        Dilan Lee <dilee@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Fri, 21 Sep 2012 07:59:48 +0200
Subject: RE: [PATCH] pwm-backlight: Take over maintenance
Thread-Topic: [PATCH] pwm-backlight: Take over maintenance
Thread-Index: Ac2XHcqQlYHr/WVlTBanBtFd2sGZwQAn5FQQ
Message-ID: <F45880696056844FA6A73F415B568C695B44DDE234@EXDCVYMBSTM006.EQ1STM.local>
References: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Arun Murthy <arun.murthy@stericsson.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Robert Morell <rmorell@nvidia.com>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> Andrew: As previously discussed this patch makes me the new maintainer
> for the pwm-backlight driver. I contacted Richard Purdie and requested his
> Acked-by for this because he's the backlight subsystem maintainer.
> Unfortunately he hasn't answered yet. Looking at the commit log, every
> commit in the last 2+ years has gone through your tree, which seems to be
> reason enough for me to take over this driver but I still wanted to get an
> Acked-by at least from you so that this doesn't look like hijacking. I've also
> Cc'ed a couple of people that have done work on the driver in the past to
> give them a chance to object or send their Acked-by.

Acked-by: Arun Murthy<arun.murthy@stericsson.com>

I hope now the review process will be fast instead of going through Andrew's
tree.
All the Best!
Now I think I can re-start my pwm core driver thread, since I have a maintainer
for this :-)

Thanks and Regards,
Arun R Murthy
------------------
