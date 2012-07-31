Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2GaU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:58:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab2GaU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:58:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/6] ARM: ux500: Remove unused snowball_of_platform_devs struct
Date: Tue, 31 Jul 2012 20:58:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1343741493-17671-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312058.24640.arnd@arndb.de>
X-Provags-ID: V02:K0:lAVenwzMjcdKGTLnUzDmrfJQduoTsXai1vhl9RkWTMW
 W+gmnp+3t4GNq3C3PyVZTqxb45D/gra6F4aaikZliU32uLVXhK
 jASvNr4dPZcMMwP7HFM/SPc00SPxu0llL0sFbS1tx8dXWw6tgd
 THz2/jbqAj3KwPpSY7f6tNZvaFSDHZjdFREJszxHoqdairqMS1
 DMBPyb3aI1wscJSGSdRtqZLc5qD62sFM5YZgEPdIpGfpAhdYM0
 U4WelmArv6vygSfHXlnEXbWKpbMrp7yEcbG+72MqexHBN8SFLa
 k1pa36tJmm+tGltjItACFWofMaR+wbMPFNtFNMu7HruLlU1oIH
 l9N4ZnE/U89Cq2fTTbl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Lee Jones wrote:
> This was left over during a recent clean-up which removed Device Tree
> helper structs. There is no longer a requirement for it, so we can just
> remove it.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
