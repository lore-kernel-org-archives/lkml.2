Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2K0OeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:34:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40757 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2K0OeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:34:12 -0500
Date: Tue, 27 Nov 2012 14:34:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linus.walleij@stericsson.com, arnd@arndb.de,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: bu21013_ts - Request a regulator that
 actually exists
Message-ID: <20121127143407.GG2013@gmail.com>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-2-git-send-email-lee.jones@linaro.org>
 <20121127133404.GA13065@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121127133404.GA13065@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Mark Brown wrote:

> On Tue, Nov 27, 2012 at 01:13:08PM +0000, Lee Jones wrote:
> > Currently the BU21013 Touch Screen driver requests a regulator by the
> > name of 'V-TOUCH', which doesn't exist anywhere in the kernel. The
> > correct name, as referenced in platform regulator code is 'avdd'. Here,
> > when we request a regulator, we use the correct name instead.
> 
> The regulator should be requested using whatever the name for the supply
> in the datasheet - AVDD does sound very pluasible but it'd be good to
> check.

Right. 'avdd' is correct.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
