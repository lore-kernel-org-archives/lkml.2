Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2GaPK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:10:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47091 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926Ab2GaPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:10:27 -0400
Date: Tue, 31 Jul 2012 16:10:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 18/19] Documentation: Define the MSP Driver Device Tree
 bindings
Message-ID: <20120731151024.GA4468@opensource.wolfsonmicro.com>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
 <1343741953-17828-19-git-send-email-lee.jones@linaro.org>
 <20120731135539.GO4468@opensource.wolfsonmicro.com>
 <5017F2E2.4040100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017F2E2.4040100@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:59:46PM +0100, Lee Jones wrote:
> On 31/07/12 14:55, Mark Brown wrote:

> >>+Optional properties:
> >>+ - interrupts       : The interrupt outputs from the device.

> >If there's more than one interrupt then how are they ordered?

> It doesn't matter. If there are any more than one (which there
> aren't in this case), we usually use the interrupt-names property
> then request them by name in the driver.

So the binding therefore needs to say "The interrupt output from the
device" as there's only one output supported.  If we were using
interrupt-names then we'd need to document what the supported names are.
