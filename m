Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2HMM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:29:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51569 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2HMM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:29:37 -0400
Date: Mon, 13 Aug 2012 13:29:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [RFC PATCH] spi/bcm63xx: Ensure that memory is freed only after
 it is no longer used
Message-ID: <20120813122934.GB13446@opensource.wolfsonmicro.com>
References: <1344632187-9603-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344632187-9603-1-git-send-email-linux@roeck-us.net>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 01:56:27PM -0700, Guenter Roeck wrote:
> The call to spi_unregister_master() in the device remove function frees device
> memory, and with it any device local data. However, device local data is still
> accessed after the call to spi_unregister_master().

Applied, thanks.
