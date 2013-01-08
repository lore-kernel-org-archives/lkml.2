Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3AHNHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:07:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHNHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:07:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] gpiolib: add gpiod_get and gpiod_put functions
Date: Tue, 8 Jan 2013 13:07:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Alexandre Courbot <gnurou@gmail.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <1357629535-26033-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1357629535-26033-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081307.04229.arnd@arndb.de>
X-Provags-ID: V02:K0:3oWc8gdvKIPUQRchbMCrSlwIN+8Dvev0ZtwVTkjVBVD
 AuzgMRd78SloJa3slVERF3wWX7X0L5FRdRsajDCbzEXXsMqWrL
 SmmjnLaGukoEQdVHRkujvFaeVk/8icuKl8SLhkQPvwlT4glAZC
 puO43uJTDox5nYWX938Sl6OYCdsS5mBEGc7+oV1AdUndTm/jHa
 xMbTGeT3RaPGdAJaE7oXDvckzHAI+VMdRSeKlf1HCJeRXzPBbr
 KG1mCmaFRtnI4J7ef0I8k6fYQl1QJ1YTvlbgKCis0GSZQaa6TA
 bO62dkaENwNSX7yY4ka3FVAolzLIhMJuLSmT5pEasCuVIsKEhL
 4CChtZE0SXyHcAEzhiz0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Alexandre Courbot wrote:
> 
> Adds new GPIO allocation functions that work with the opaque descriptor
> interface.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I think you need to reorder the patches slightly, since the gpiod_get
function introduced here is already being used in the first patch, which
breaks bisection.

	Arnd
