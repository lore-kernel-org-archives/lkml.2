Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2DTPzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:55:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2DTPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:55:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: Defconfig update for LPC32xx
Date: Fri, 20 Apr 2012 14:54:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <4F904795.4050505@antcom.de>
In-Reply-To: <4F904795.4050505@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204201454.09200.arnd@arndb.de>
X-Provags-ID: V02:K0:WLUO5Z+V6KiQoOyjN+f5DwnNiDkmiV+ZLEvm7CMD35b
 7yxSd3AL3ywQCpQj5sWHhkn8Wf9TJvq54TXH5cSZVhzTavO2oQ
 pwykxyIGAu+ts3SzmphfLaG3hE3qr2SyrEfER9AbkU0zMoYGhK
 Pw0+z3w4I1DhhDaW+PaiTWzzh6ztYdxij+4ZKx2FvKEMFxYH1i
 I53ZAnYkimX9cIiM7CQv7KfHHJJwfZTKthqECW5eO+mQJ2sD4M
 MN+wy38wyRoGR5s/e9dzXuuFWEAK3kHfSNebpDUn2aXHcmLs0c
 nz0pBXqPOHwcIJyzmozH63hYhG6kp+Dt6G3rubRiq/S2JglBTZ
 6tgrN6vaCZK83tkFkQT4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2012, Roland Stigge wrote:
> Hi,
> 
> I'm planning to update arch/arm/configs/lpc32xx_defconfig, adjusting to
> device tree and new driver options.
> 
> Now I wonder if I should (1) just add drivers which are used on the
> reference machine (PHYTEC LPC3250 board) or (2) additionally add all
> drivers that I have seen together with LPC32xx on other boards also,
> which would demonstrate that the same binary kernel runs on all LPC32xx
> machines, but increasing kernel size a bit.
> 
> I would prefer option (2) but first want to ask for advice.

I think either way is fine, this is one of the things I would completely
leave to you as the platform maintainer.

If you know that other machines are working with the same defconfig,
it would be helpful to also have their .dts files in the kernel source
for reference, but not mandatory.

	Arnd
