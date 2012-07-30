Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2G3Nk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:40:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab2G3Nk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:40:56 -0400
Date: Mon, 30 Jul 2012 14:40:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 13/18] ARM: ux500: Add ux500 PCM to DB8500 Device Tree
Message-ID: <20120730134054.GC4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-14-git-send-email-lee.jones@linaro.org>
 <20120729205001.GK4384@opensource.wolfsonmicro.com>
 <5016389B.4020003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016389B.4020003@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 08:32:43AM +0100, Lee Jones wrote:
> On 29/07/12 21:50, Mark Brown wrote:
> >On Fri, Jul 27, 2012 at 01:45:57PM +0100, Lee Jones wrote:

> >>+		pcm: ux500-pcm {
> >>+			compatible = "stericsson,ux500-pcm";
> >>+		};
> >>+

> >One of two things is wrong here.  Either you've not provided any
> >information about the hardware so the driver won't be able to work out
> >what to talk to or you've not provided any data so you're registering a
> >purely virtual Linux-internal device via the device tree.

> >Once more, the idea here is to describe the hardware not to dump Linux's
> >internal data structures into the device tree.

> We use it register the driver for probe()ing. In the same way we do
> for the PMU and Regulators. All three of which actually belong to a
> different hardware block. Do you know of a better way to register
> those devices?

You've not identified which of the two cases above we're in...  assuming
it's a virtal device look at how the DT bindings for the other platforms
are doing things.
