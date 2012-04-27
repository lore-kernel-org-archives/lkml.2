Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab2D0Mz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:55:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab2D0Mzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:55:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Default Kconfig state for hw_random drivers
Date: Fri, 27 Apr 2012 12:55:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        balbi@ti.com, Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20120426114229.GG3207@opensource.wolfsonmicro.com> <4F9A91A8.4050608@atmel.com> <20120427123626.GH18260@opensource.wolfsonmicro.com>
In-Reply-To: <20120427123626.GH18260@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271255.36789.arnd@arndb.de>
X-Provags-ID: V02:K0:yssZoFjLMgtIP9+nJ9xTCTkzn2bIf9/UKQVeqax/Iea
 aFiCHRmDu8EUArLu7iEnKqKxVCTa1RbSmbpCE3hnfRFgH6NQmw
 +vEANUVwIOOqDjrhQWeSHIm3N4dVXpV4dDCd2iSxJpt9jVWPRL
 v8ow7ppMzZGoqZNqoG/3dSWIf/MlFB9Vt9fY1pWA0KPatBi1/f
 TlnW6m4XfLc1bfQzMZGgPbeL2Fegw2fFHCtnbTP2Hv/s+EO8Ye
 r7BJKSWep0dD3YavlvcfNM+RBiikZUF6tc4e7DxEtOQ82b59wL
 weatbxGl0cGZFm69FGq9wgV4gQQRFYBuNcteEWrHQQ7zytd4A8
 ms+BQStf3A2haNljOoEc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2012, Mark Brown wrote:
> There is one, that's the problem - the driver is defaulting to the same
> state as the main hw_random option (as is idiomatic for this subsystem).
> This means that if you've enabled any hw_random device this driver will
> be enabled by default.  I would argue that this default directive only
> makes sense if there's an explicit dependency limiting the platforms it
> can build on.  If it can build on any platform then omitting the default
> and just defaulting to N as is normal for drivers would be better.

How about making it default to (HW_RANDOM && ARCH_AT91) then?

	Arnd
