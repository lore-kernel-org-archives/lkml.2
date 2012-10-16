Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2JPFOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:14:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755846Ab2JPFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:14:20 -0400
Date: Tue, 16 Oct 2012 14:14:04 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] regulator: gpio-regulator: Allow use of GPIO
 controlled regulators though DT
Message-ID: <20121016051401.GB8670@opensource.wolfsonmicro.com>
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:16:59PM +0100, Lee Jones wrote:
> Here we provide the GPIO Regulator driver with Device Tree capability, so
> that when a platform is booting with DT instead of platform data we can
> still make full use of it.

Not looked at the patch yet but patch 2 doesn't seem to have appeared?
