Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2G3PC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:02:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57513 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab2G3PCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:02:54 -0400
Date: Mon, 30 Jul 2012 16:02:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 13/18] ARM: ux500: Add ux500 PCM to DB8500 Device Tree
Message-ID: <20120730150252.GG4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-14-git-send-email-lee.jones@linaro.org>
 <20120729205001.GK4384@opensource.wolfsonmicro.com>
 <5016389B.4020003@linaro.org>
 <20120730134054.GC4468@opensource.wolfsonmicro.com>
 <501699B2.7030002@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501699B2.7030002@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:26:58PM +0100, Lee Jones wrote:
> On 30/07/12 14:40, Mark Brown wrote:

> >>We use it register the driver for probe()ing. In the same way we do
> >>for the PMU and Regulators. All three of which actually belong to a
> >>different hardware block. Do you know of a better way to register
> >>those devices?

> >You've not identified which of the two cases above we're in...  assuming
> >it's a virtal device look at how the DT bindings for the other platforms
> >are doing things.

> I thought it would have been obvious by my response. The PMU seems
> to be a virtual device with no registers or IRQs.

That's not at all obvious, no.

> I've found a DT which seems to do it in the same way as I do
> 'arch/powerpc/boot/dts/p1022ds.dts', but some others call PCM
> registration from the CPU-side DAI probe(). Would that be your
> preference?

Yes, do what the other drivers are doing
