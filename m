Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2K1I5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:57:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42933 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2K1I5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:57:37 -0500
Date: Wed, 28 Nov 2012 08:57:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121128085731.GH2013@gmail.com>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
 <20121128070332.GC23378@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121128070332.GC23378@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> On Tue, Nov 27, 2012 at 01:13:10PM +0000, Lee Jones wrote:
> > Now we can register the BU21013_ts touch screen when booting with
> > Device Tree enabled. Here we parse all the necessary components
> > previously expected to be passed from platform data.
> 
> I applied these 3 patches, but for DT we also need to specify compatible
> ID and set up of_match_table pointer. 

Why do you need a compatible string?

> Please send me a follow-up patches
> doing that and also describing DT bindings for BU21013.

I'll send the documentation as a seperate reply to your email.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
