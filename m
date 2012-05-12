Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2ELNVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 09:21:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2ELNVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 09:21:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v9 2/2] gpio: Device tree support for LPC32xx
Date: Sat, 12 May 2012 13:21:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: glikely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
References: <1336729660-7670-1-git-send-email-stigge@antcom.de> <1336729660-7670-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1336729660-7670-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205121321.33106.arnd@arndb.de>
X-Provags-ID: V02:K0:MaAzwgVJKPagqACPMpt8oa+Rq2GGGLuTGk9lM4M7EWg
 BG1Nc+V9DO+aniLKzdco99xr19llxJq/2Y48XRK7g4SwDcP+MD
 kF5tZ4t/iUdpR/78DjAhEozDCRpTYEWHWWf/6CWfe3U/cHGRgT
 yTpDNyjyfvJNxo16LTgoHo7teqcf4bvv2X3XyhxCvwfMM9UjDe
 rTkqktmwMlYup4c5IfozOiFx8E/TGdcIMEuPz9AeFswXOkrWlT
 GXm2YkiOs8sKj8iJEUjsSrH5nAjsUNWI4GDTQmokNKxawn8cHU
 MHFPC0sp2Qh+Xc2SAHR1TkKARR9XS5R3l5L5RFK6ne3YMxnQsp
 RRKiZ1UHogWCHHMl58oI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012, Roland Stigge wrote:
> This patch adds device tree support for gpio-lpc32xx.c.
> 
> To register the various GPIO banks as (struct) gpio_chips via the same DT
> gpio-controller, we utilize the adjusted of_xlate API to manipulate the
> actually used struct gpio_chip.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
