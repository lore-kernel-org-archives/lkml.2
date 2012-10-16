Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2JPHaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:30:03 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50132 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2JPHaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:30:00 -0400
Date: Tue, 16 Oct 2012 08:29:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] regulator: gpio-regulator: Allow use of GPIO
 controlled regulators though DT
Message-ID: <20121016072956.GF7662@gmail.com>
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
 <20121016051401.GB8670@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121016051401.GB8670@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Mark Brown wrote:

> On Mon, Oct 15, 2012 at 02:16:59PM +0100, Lee Jones wrote:
> > Here we provide the GPIO Regulator driver with Device Tree capability, so
> > that when a platform is booting with DT instead of platform data we can
> > still make full use of it.
> 
> Not looked at the patch yet but patch 2 doesn't seem to have appeared?

Has it arrived yet?

Arnd responded to it, so it hit the list.

Since Arnd's comments I've also fired v2 up - do you see it/them?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
