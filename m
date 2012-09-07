Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2IGMa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:30:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760439Ab2IGMa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:30:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 05/19] ARM: ux500: Stop registering HREF's SDI devices from platform data
Date: Fri, 7 Sep 2012 12:30:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <1347016499-29354-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1347016499-29354-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071230.21397.arnd@arndb.de>
X-Provags-ID: V02:K0:QzyLHpqQTfOmV1XeBHJrWNWOKcUymXQiMnu0owUdPwz
 C9cgSoRzOO7dumtWwqw1UKW6dnZvxfmeeFWpX/9+cKPRAe5q7j
 6VaCL+nPReOWuXD2pNjyztFOlVYeXiZIYBHqMaMpeOWG3pdEXp
 UUdfxgUHSbbYqPk4uZ1U/cWt6gqsOtgk73u4mul0FdS6yxLJo/
 4pl4EISdFjJSdyQtz/xQd64vlfdpvfUOqwqCv2YbPp+IK4K/7u
 PktzGMgeKqqjvMXY3XniJrKLMczqbcGdEOq2VwMvIfwJcfxGlV
 cJzj+R/gznJ6xeTn8VFRbv9ZbLla30an5zrhGieQm38jMl2Ju8
 cuqnMP9Pxduw2SK2PPSk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> 
> The HREF Device Tree now has support for its four SDIs. So, if we
> continue registering them from platform code when Device Tree is
> enabled we'll cause a double probe of the same devices. To prevent
> that we'll just remove registration.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500.c |    1 -
>  1 file changed, 1 deletion(-)

The change is ok, but I think it should go into the same patch
as the one before, so you can atomically switch from one to the other.

	Arnd
