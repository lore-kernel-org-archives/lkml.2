Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2GENvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:51:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2GENvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:51:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/9] ARM: ux500: Remove AB8500 regulator register initialisation information
Date: Thu, 5 Jul 2012 13:51:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-4-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341493572-29735-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051351.03115.arnd@arndb.de>
X-Provags-ID: V02:K0:9e1rPOvNZVNkQsMMxQ22coTdqoLxouYV9xTzEsYfj6e
 0Dd7Hvinqs3Gc45Z4UfcmZ16sg+T+2JSAyXaYCh61CObINQ3OS
 bO2m+nm2f5VWCHGcr4y6CJmPOScJMKGaQwaxAkQv8wYjcecA5U
 zOIRtrOgYzfilrSZXoPK4UvMl+tASzwC9Y+uVh39nVeX99RLsi
 RAZegWhggpkrBrqjk63ZkJCbUiJ14OGafFhv+hW5kCKcvN5osJ
 ve0RyRYGVSVNNtYCiC2NLDzcrYWWhyQm+C/Q7gQxP0Wrz/dC0B
 Iz3f0u37q/mhbMclVKXFaN0KAH5yGM7MIfRSm+lHp1XoF3tsB6
 1WBVM+gDQUz94no3cP94=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012, Lee Jones wrote:
> There is no need to initialise the AB8500's regulator registers, as
> most of this work is already carried out by framework features, so
> we can safely remove all traces from platform code.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

It makes sense, but this patch is basically a revert of dfa3a824d
"mach-ux500: provide ab8500 init vector" from Bengt Jonsson, so
it would be nice to get an Ack from him.

	Arnd
