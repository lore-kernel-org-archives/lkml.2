Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2JQH1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:27:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47744 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab2JQH1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:27:53 -0400
Date: Wed, 17 Oct 2012 16:27:48 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stan Hu <stanhu@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] spi: omap2-mcspi: add option to configure output
 line for McSPI driver
Message-ID: <20121017072746.GG14199@opensource.wolfsonmicro.com>
References: <y>
 <1349735980-17015-1-git-send-email-stanhu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349735980-17015-1-git-send-email-stanhu@gmail.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:39:40PM -0600, Stan Hu wrote:
> McSPI driver previously assumed that D0 was input (MISO) and D1 was output (MOSI).
> This forces the hardware designer to wire all SPI peripherals in this way when
> it should be a software configuration option.

I applied a similar patch from Daniel Mack just now; please check if
there's anything he's missing.  His patch was sent earlier and also adds
DT bindings.
