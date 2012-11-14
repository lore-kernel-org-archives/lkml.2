Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422684Ab2KNLuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:50:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139Ab2KNLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:50:06 -0500
Date: Wed, 14 Nov 2012 11:50:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Frank Li <Frank.Li@freescale.com>
Subject: Re: [PATCH 1/1] regulator: gpio-regulator: Catch 'no states
 property' misuse
Message-ID: <20121114115000.GA2941@gmail.com>
References: <1352892888-15546-1-git-send-email-lee.jones@linaro.org>
 <20121114114302.GN7407@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121114114302.GN7407@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Mark Brown wrote:

> On Wed, Nov 14, 2012 at 11:34:48AM +0000, Lee Jones wrote:
> > A selection of voltage or current values (AKA states) should always
> > be specified when using a GPIO regulator. If there are no switchable
> > states then the fixed regulators should be used instead.
> 
> Applied, thanks.

Ah, sorry Mark, can you unapply this please?

I didn't add my fixups.

Resending.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
