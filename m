Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2HAQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:08:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48350 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab2HAQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:08:27 -0400
Date: Wed, 1 Aug 2012 17:08:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120801160824.GB11892@opensource.wolfsonmicro.com>
References: <20120731134214.GK4468@opensource.wolfsonmicro.com>
 <5017EAC3.3080504@linaro.org>
 <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50193428.5000708@linaro.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:50:32PM +0100, Lee Jones wrote:

> I am under the impression that it was tested. Perhaps before it was
> rebased, but tests were completed. Ola was very surprised when I
> told him there were link failures. The only issue is that I only
> found out and told him a day before he was due to take his Summer
> leave.

That's really surprising.  What are the actual issues here, you've never
shown the actual errors?

> >It's very disappointing to see such an error exist, and even more
> >disappointing that there's no interest in fixing the driver.

> This is incorrect. I'm sure the driver will be fixed post-haste when
> Ola returns back from vacation. If I can find some time I might
> dabble in the mean-time also.

It may not be what you're intending but it's unfortuantely what's I'm
seeing.
