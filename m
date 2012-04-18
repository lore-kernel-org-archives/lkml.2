Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2DRWCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:02:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2DRWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:02:31 -0400
Date: Wed, 18 Apr 2012 15:02:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, dan.carpenter@oracle.com
Subject: Re: [PATCH v3 7/10] iio: lpc32xx-adc: Remove driver conflict due to
 device tree
Message-ID: <20120418220226.GA8035@kroah.com>
References: <1334756176-25144-1-git-send-email-stigge@antcom.de>
 <1334756176-25144-8-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334756176-25144-8-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:36:12PM +0200, Roland Stigge wrote:
> Previously, the touchscreen and ADC drivers of the LPC32xx SoC had a Kconfig
> conflict declared because they use the same hardware. Upon the introduction of
> device tree support in both drivers, the conflict must be removed to enable
> the same kernel to support different hardware (configured via the device tree).
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

