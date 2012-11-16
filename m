Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab2KPISM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:18:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2KPISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:18:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob.clark@linaro.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Date: Fri, 16 Nov 2012 08:18:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, Rob Clark <rob@ti.com>
References: <1353016879-15007-1-git-send-email-rob.clark@linaro.org>
In-Reply-To: <1353016879-15007-1-git-send-email-rob.clark@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211160818.01302.arnd@arndb.de>
X-Provags-ID: V02:K0:QNE9+qU00XaqCxjTFbzOamldKZTj1GTm0tfSULVqCZ0
 HUTXQFsSjFLFU7IQm80NiFiYP2V7mDdUbhzvFUCj2zSZPkedyN
 BJUZPqfhWe7eks4fHtj7ro4QH06Sm+ZJ9Xqpk9g2XuNL/b6Igr
 5NuqsF6hMeXTAc1cEfKdrr5oy5mVMLWwMPlbuuK08X58UcgbrY
 nwz08HvEg5jYKJn7A/8f0yF8SYkH4br2nwP3eER+9lPjwxazo8
 OlOUeIlcyTbmVtiscP16L7tKHpliicXt8h+6YJCIDrGBrWzZH/
 8museAw5f+Cp+pTyRDyBtGDZaAdNabRKn6ed1srxwrb/paM6rj
 2Jo/8/8YI3IEG9oFu5Yc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Rob Clark wrote:
> 
> From: Rob Clark <rob@ti.com>
> 
> A new atomic modeset/pageflip ioctl being developed in DRM requires
> get_user() to work for 64bit types (in addition to just put_user()).
> 
> v1: original
> v2: pass correct size to check_uaccess, and better handling of narrowing
>     double word read with __get_user_xb() (Russell King's suggestion)
> v3: explain in comment about why this works for narrowing fetch to 1,
>     2, or 4 byte type on ARM.
> 
> Signed-off-by: Rob Clark <rob@ti.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
