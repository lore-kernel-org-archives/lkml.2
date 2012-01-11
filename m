Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2AKRpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:45:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53816 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757900Ab2AKRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:45:42 -0500
Date: Wed, 11 Jan 2012 17:45:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        kyungmin.park@samsung.com, cbou@mail.ru, kwangwoo.lee@gmail.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, patches@linaro.org
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
	gpio controlled panel reset
Message-ID: <20120111174540.GE24213@opensource.wolfsonmicro.com>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org> <4F05F509.6020405@metafoo.de> <20120106064929.GB3496@opensource.wolfsonmicro.com> <CAJuYYwRxuZAm_JpLw1fN2ypnFc6TocH6veRmCeuqENvZHSz3kg@mail.gmail.com> <20120107172826.GA355@opensource.wolfsonmicro.com> <CAJuYYwSuDzUWgnSJHO0vwjYH7zscC9=j_=JuOUuJy9shHpPUuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwSuDzUWgnSJHO0vwjYH7zscC9=j_=JuOUuJy9shHpPUuA@mail.gmail.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 04:21:57PM +0530, Thomas Abraham wrote:

> In the case of Exynos4 based Origen board, buck7 of max8997 supplies
> power to the lcd panel. buck7 is capable of supplying power at
> different voltage levels but for Origen board, it is required to
> supply only 3.3V. The constraints for buck7 can specify 'apply_uV' and
> this will ensure that buck7 is configured to supply 3.3V.

> But 'apply_uV' seems to be not ideal for regulators that supply power
> to lcd panels. It would be better to power lcd panels only when video
> data has to be displayed.

What makes you say this?  Enabling and disabling a regulator are
entirely orthogonal to setting the regulator voltage.
